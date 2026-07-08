make -j20 O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-android- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-gnueabi- LD=ld.lld LLVM=1 LLVM_IAS=1 $1

cp out/arch/arm64/boot/dts/vendor/xiaomi/veux.dtb out/arch/arm64/boot/dts/vendor/xiaomi/veux_no.dtb

#fdtoverlay -i out/arch/arm64/boot/dts/vendor/xiaomi/veux_no.dtb \
#           -o out/arch/arm64/boot/dts/vendor/xiaomi/veux.dtb \
#           out/arch/arm64/boot/dts/vendor/xiaomi/veux-overlay.dtbo
