#!/usr/bin/env perl
# This is the place and route script for Digital Integrated Circuit
# Design 2.
#
# It takes in a Verilog description of a design and runs it through
# the RTL Compiler for optimization, then through Cadence's Encounter
# tool.
use warnings;

my $numArgs = $#ARGV + 1;
print "Parsing $numArgs Verilog Files.\n";

# Variables we'll need.
my $m;
my $highest;
my $line12;
my $Top_Module;
my $hdl_files;
my $config_dir="./src/PandR/";
my $work_dir="./workdir/";

# Create a working directory if it doesn't already exist.
mkdir $work_dir unless -d $work_dir;

# If we don't have a file list, print usage.
if($numArgs == 0)
{
    print "Usage: PR.pl sample1.v sample2.v ...\n";
}
# Else do our thing.
else
{
    # For each Verilog file, remove the gnd and vdd nets. Don't worry
    # about line splits or case sensitivity.
    foreach $argnum (0 .. $#ARGV)
    {
        open Verilog_File, "$ARGV[$argnum]" or die "couldn't open Verilog file";

        # WARNING: This pulls in the whole file into a variable.
        my $Verilog_Code = do { local $/; <Verilog_File> };

        close (Verilog_File);

        # We should think about naming the file something other than the
        # original one, because that's destructive.
        open New_Verilog_File, ">$ARGV[$argnum]" or die "couldn't open Verilog file";

        # Remove the gnd and vdd nets and their permutations.
        $Verilog_Code =~ s/,\s+gnd//mgi;
        $Verilog_Code =~ s/,\s+vdd//mgi;
        $Verilog_Code =~ s/,\s+\.gnd\(gnd\)//mgi;
        $Verilog_Code =~ s/,\s+\.vdd\(vdd\)//mgi;

        # While we're at it, lets comment out the specify and endspecify
        # block if it exists.
        $Verilog_Code =~ s/^specify/\/\* specify/g;
        $Verilog_Code =~ s/^endspecify$/endspecify \*\//g;

        # Write it out to a file.
        print New_Verilog_File "$Verilog_Code";
        # MOAR NEWLINES!
        print New_Verilog_File "\n";

        close(New_Verilog_File);
    }

    # This builds a list of files to parse.
    $hdl_files = '{ ';
    for ($m = 0; $m < $numArgs; $m++)
    {
         $hdl_files = $hdl_files . $ARGV[$m] . " ";
    }
    $Top_Module = $ARGV[0];
    chop($Top_Module);
    chop($Top_Module);
    #print "\nTop = $Top_Module\n";

    #print "\nhdl_Files = $hdl_files\n";

    # Grab the contents of the rc.tcl file.
    open RC_File, $config_dir."./rc.tcl" or die "couldn't open file";

    my @RTL_Code = <RC_File>;

    $highest = $#RTL_Code;

    close (RC_File);

    open New_RC_File, ">".$work_dir."./RC.tcl" or die "couldn't open file";

    # Set the file names in the design and the top level module in the
    # RTL Compiler tcl file.
    for($m = 0; $m <= $highest; $m++)
    {
       $line12 = $RTL_Code[$m];
    #   print "Line Before: $line12\n";
       if($line12 =~ 'set hdl_files')
       {
          $line12 = "set hdl_files " . $hdl_files . "}";
       }
       if($line12 =~ 'set DESIGN')
       {
          $line12 = "set DESIGN " . $Top_Module;
       }

       print New_RC_File "$line12";
    }

    close(New_RC_File);

    open Encounter_File, $config_dir."./encounter.conf" or die "couldn't open file";

    my @Encounter_Code = <Encounter_File>;

    $highest = $#Encounter_Code;

    close (Encounter_File);

    open New_Encounter_File, ">".$work_dir."./encounter.conf" or die "couldn't open file";

    for($m = 0; $m <= $highest; $m++)
    {
       $line12 = $Encounter_Code[$m];
    #   print "Line Before: $line12\n";
       if($line12 =~ 'set my_toplevel')
       {
          $line12 = "set my_toplevel " . $Top_Module;
       }
       print New_Encounter_File "$line12";
    }

    close(New_Encounter_File);#!/usr/bin/env perl

    # Run both the RTL Compiler and Encounter using the newly munged
    # tcl files. This is the part that does the actual P&R, so go read
    # those files.
    system("rc < ".$work_dir."RC.tcl");
    system("encounter -init ".$config_dir."encounter.tcl");
}
