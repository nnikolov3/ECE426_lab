#---- Calibre user setup ----------------------------------------------
export MGC_HOME=/pkgs/mentor/calibre/2013/ixl_cal_2013.2_35.25
export PATH=${MGC_HOME}/bin:${PATH}
export LM_LICENSE_FILE=1717@license.cecs.pdx.edu

# rule sets for layout workflow
export MGC_CALIBRE_DRC_RUNSET_FILE=$PWD/src/calibre/runset.calibre.drc
export MGC_CALIBRE_LVS_RUNSET_FILE=$PWD/src/calibre/runset.calibre.lvs
export MGC_CALIBRE_PEX_RUNSET_FILE=$PWD/src/calibre/runset.calibre.pex
