###################################
# Run the design through Encounter
# File downloaded from OSU kit
# Edited on 01/27/2010 by Vivek Bakshi
# Fixed some of the old commands to support the new commands
###################################

set WORKDIR ./workdir/

# Setup design and create floorplan
loadConfig ${WORKDIR}encounter.conf 

# Create Initial Floorplan
floorplan -r 1.0 0.6 20 20 20 20

# Create Power structures
addRing -spacing_bottom 5 -width_left 5 -width_bottom 5 -width_top 5 -spacing_top 5 -layer_bottom metal5 -width_right 5 -around core -center 1 -layer_top metal5 -spacing_right 5 -spacing_left 5 -layer_right metal6 -layer_left metal6 -nets { gnd vdd }

# Place standard cells
placeDesign

# Route power nets
sroute -noBlockPins -noPadRings

# Perform trial route and get initial timing results
setTrialRouteMode -maxRouteLayer 6 -minRouteLayer 1
trialRoute 
buildTimingGraph
timeDesign -reportOnly -pathReports -slackReports -numPaths 50 -outDir timingReports


# Run in-place optimization
# to fix setup problems
setUsefulSkewMode -maxSkew false -noBoundary false 
setOptMode -effort high -usefulSkew true
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS

# Run Clock Tree Synthesis
setCTSMode -routeClkNet true -routeGuide true
createClockTreeSpec -output encounter.ctstch
specifyClockTree -file encounter.ctstch
ckSynthesis -ignoreLoopDetect -fix_added_buffers -rguide clock.rguide

# Output Results of CTS
trialRoute -highEffort -guide clock.rguide
extractRC
reportClockTree -postRoute -localSkew -report skew.post_troute_local.ctsrpt
reportClockTree -postRoute -report report.post_troute.ctsrpt

# Run Post-CTS Timing analysis
setAnalysisMode -setup -async -skew
buildTimingGraph
timeDesign -reportOnly -pathReports -slackReports -numPaths 50 -outDir timingReports

# Perform post-CTS IPO
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute -drv

# Fix all remaining violations
setExtractRCMode -detail -assumeMetFill
extractRC


# Run Post IPO-2 timing analysis
timeDesign -reportOnly -pathReports -slackReports -numPaths 50 -outDir timingReports

# Add filler cells
addFiller -cell FILL -prefix FILL -fillBoundary

# Connect all new cells to VDD/GND
globalNetConnect vdd -type tiehi
globalNetConnect vdd -type pgpin -pin vdd -override

globalNetConnect gnd -type tielo
globalNetConnect gnd -type pgpin -pin gnd -override

# Run global Routing
globalDetailRoute

# Get final timing results
setExtractRCMode -detail -noReduce
extractRC
timeDesign -reportOnly -pathReports -slackReports -numPaths 50 -outDir timingReports

# Output GDSII
streamOut ${WORKDIR}final.gds2 -mapFile ./src/PandR/gds2_encounter.map -stripes 1 -units 1000 -mode ALL
saveNetlist -excludeCellInst FILL final.v
global dbgLefDefOutVersion
set dbgLefDefOutVersion 5.6

# Output DSPF RC Data
rcout -spf ${WORKDIR}final.dspf

# Run DRC and Connection checks
verifyGeometry
verifyConnectivity -type all

win

puts "**************************************"
puts "* Encounter script finished          *"
puts "*                                    *"
puts "* Results:                           *"
puts "* --------                           *"
puts "* Layout:  final.gds2                *"
puts "* Netlist: final.v                   *"
puts "*                                    *"
puts "* Type 'exit' to quit                *"
puts "*                                    *"
puts "**************************************"
