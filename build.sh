PATH=$PWD/toolchain/bin:$PATH
export LLVM_DIR=$PWD/toolchain/bin
export CC=clang
export LD=ld.lld


export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

ARGS='
CC=clang
LD=ld.lld
ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu-
CROSS_COMPILE_ARM32=arm-linux-gnueabi-
CLANG_TRIPLE=aarch64-linux-gnu-
AR='${LLVM_DIR}/llvm-ar'
NM='${LLVM_DIR}/llvm-nm'
OBJCOPY='${LLVM_DIR}/llvm-objcopy'
OBJDUMP='${LLVM_DIR}/llvm-objdump'
READELF='${LLVM_DIR}/llvm-readelf'
OBJSIZE='${LLVM_DIR}/llvm-size'
STRIP='${LLVM_DIR}/llvm-strip'
LLVM_AR='${LLVM_DIR}/llvm-ar'
LLVM_DIS='${LLVM_DIR}/llvm-dis'
LLVM_NM='${LLVM_DIR}/llvm-nm'
'

make clean && make distclean
clear
make ${ARGS} KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y m21_defconfig
make ${ARGS} KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j$(nproc)


echo "Cleaning Stuff"
rm -rf AIK/Image
rm -rf config
echo "done"
echo ""
echo "Copying Stuff"
cp -r arch/arm64/boot/Image AIK/Image
cp -r .config AIK/config
echo "done"
echo ""
kver=$(make kernelversion)
kmod=$(echo ${kver} | awk -F'.' '{print $3}')
echo "Zipping Stuff"
cd AIK
rm -rf N_KERNEL.*.zip
zip -r1 N_KERNEL.${kmod}_CLANG_18_${DEVICE}.zip * -x .git README.md *placeholder
cd ..
echo "Ready to Flash"
