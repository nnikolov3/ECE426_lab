#---- NCSU FreePDK45 user setup ----------------------------------------------
base_dir=/pkgs/cadence/05-2013-rhel5
export PDK_DIR=$base_dir/local/45nPDK/FreePDK45
export CDK_DIR=$base_dir/local/45nPDK/ncsu-cdk-1.6.0.beta
export OSU_FREEPDK=$base_dir/local/45nPDK/FreePDK45/osu_soc

CNI_ROOT=/pkgs/cadence/05-2013-rhel5/local/ciranova;export CNI_ROOT
#OA_COMPILER=gcc44x;export OA_COMPILER
CNI_PLAT_ROOT=${CNI_ROOT}/plat_linux_gcc44x_64
PATH=${CNI_PLAT_ROOT}/3rd/bin:${CNI_PLAT_ROOT}/3rd/oa/bin/linux_rhel40_gcc44x_64/opt:${CNI_PLAT_ROOT}/bin:${CNI_ROOT}/bin:${PATH};export PATH
CNI_LOG_DEFAULT=/dev/null;export CNI_LOG_DEFAULT
PYTHONHOME=${CNI_PLAT_ROOT}/3rd;export PYTHONHOME
PYTHONPATH=${CNI_ROOT}/pylib:${CNI_PLAT_ROOT}/pyext:${CNI_PLAT_ROOT}/lib:${PYTHONPATH};export PYTHONPATH
LD_LIBRARY_PATH=${CNI_PLAT_ROOT}/3rd/lib:${CNI_PLAT_ROOT}/3rd/oa/lib/linux_rhel40_gcc44x_64/opt:${CNI_PLAT_ROOT}/lib:${LD_LIBRARY_PATH};export LD_LIBRARY_PATH
OA_PLUGIN_PATH=${CNI_PLAT_ROOT}/3rd/oa/data/plugins:${CNI_ROOT}/quickstart:${OA_PLUGIN_PATH};export OA_PLUGIN_PATH

export PYTHONPATH=${PDK_DIR}/ncsu_basekit/techfile/cni:${PYTHONPATH}
export PYTHONPATH=${PDK_DIR}/ncsu_basekit/techfile/cni/pycells:${PYTHONPATH}
