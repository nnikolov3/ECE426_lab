#---- Cadence user setup ----------------------------------------------
export CDS_AUTO_64BIT="ALL"
export base_dir=/pkgs/cadence/05-2013-rhel5

export SKIP_CDS_DIALOG
export CDSHOME=${base_dir}/IC615
export SPR=${base_dir}/SPR50
export IUS=${base_dir}/INCISIV122
export ICC=${base_dir}/ICC11241
export CDS_INST_DIR=${CDSHOME}
export RC=${base_dir}/RC121
export EDI=${base_dir}/EDI101
export CDS=${base_dir}
export CONFRML=${base_dir}/CONFRML121

export CDS_LIC_FILE=5280@license.cecs.pdx.edu
export CDS_Netlisting_Mode=Analog

# Path additions
export PATH=${CDSHOME}/tools/bin:${PATH}
export PATH=${CDSHOME}/tools/dfII/bin:${PATH}
export PATH=${CDSHOME}/tools/concice/bin:${PATH}
export PATH=${CDSHOME}/tools/dracula/bin:${PATH}
export PATH=${PATH}:${RC}/bin
export PATH=${PATH}:${EDI}/bin
export PATH=${base_dir}/local/bin:${PATH}
export PATH=${PATH}:${IUS}/tools/bin
export PATH=${PATH}:${IUS}/tools/dfII/bin
export PATH=${PATH}:${ICC}/tools/iccraft/bin
export PATH=${PATH}:${SPR}/BuildGates/version/bin:${SPR}/tools/bin

export PATH=${PATH}:${base_dir}/MMSIM121/tools/spectre/bin/
export PATH=${PATH}:${base_dir}/MMSIM121/tools/ultrasim/bin/

export LD_LIBRARY_PATH=${CDSHOME}/tools/lib/64bit:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${IUS}/tools/lib/64bit:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${EDI}/tools/lib/64bit:${LD_LIBRARY_PATH}
