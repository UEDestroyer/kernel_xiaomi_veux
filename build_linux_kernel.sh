#!/bin/bash
set -e

CONFIG_FILE="arch/arm64/configs/veux_defconfig"
ROOT_DIR=$(pwd)
COMPILER_PATH="/opt/android-ndk-r27d-linux/android-ndk-r27d/toolchains/llvm/prebuilt/linux-x86_64/bin"

echo "[KERNEL-BUILD] Starting pure custom Linux build for veux..."

# === 1. ТУЛЧЕЙН ===
if [ -d "$COMPILER_PATH" ]; then
    export PATH="$COMPILER_PATH:$PATH"
    echo "[KERNEL-BUILD] Clang: $($COMPILER_PATH/clang --version | head -n 1)"
else
    echo "[ERROR] NDK Toolchain not found at $COMPILER_PATH!"
    exit 1
fi

export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_HOST=$(hostname)
export KBUILD_BUILD_USER="GoogleFucksYou"
export CLANG_TRIPLE=aarch64-linux-android-
export CROSS_COMPILE=aarch64-linux-android-

# === 2. ПОЛНАЯ ОЧИСТКА ===
echo "[KERNEL-BUILD] Hard cleanup..."
rm -rf out/
rm -rf dist/
mkdir -p out

# === 3. ГЕНЕРАЦИЯ КОНФИГА ===
if [ ! -f "$CONFIG_FILE" ]; then
    echo "[FATAL] $CONFIG_FILE not found!"
    exit 1
fi

echo "[KERNEL-BUILD] Generating base config from $CONFIG_FILE..."
make veux_defconfig O=out ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1

TARGET_CONFIG="out/.config"

# === 4. ПАТЧИНГ КОНФИГА ===
echo "[KERNEL-BUILD] Patching config..."

set_config() {
    local option=$1
    local value=$2
    # Удаляем все упоминания опции (и =y/=m и # ... is not set)
    sed -i "/^${option}[= ]/d" "$TARGET_CONFIG"
    sed -i "/^# ${option} /d" "$TARGET_CONFIG"
    echo "$value" >> "$TARGET_CONFIG"
}

# --- Убираем Android-ограничения ---
set_config "CONFIG_ANDROID_PARANOID_NETWORK"  "# CONFIG_ANDROID_PARANOID_NETWORK is not set"
set_config "CONFIG_SECURITY_SELINUX"          "# CONFIG_SECURITY_SELINUX is not set"
set_config "CONFIG_DM_VERITY"                 "# CONFIG_DM_VERITY is not set"
set_config "CONFIG_DM_ANDROID_VERITY"         "# CONFIG_DM_ANDROID_VERITY is not set"
set_config "CONFIG_MODULE_SIG"                "# CONFIG_MODULE_SIG is not set"
set_config "CONFIG_SECURITY_SMACK"            "# CONFIG_SECURITY_SMACK is not set"
set_config "CONFIG_SECURITY_APPARMOR"         "# CONFIG_SECURITY_APPARMOR is not set"
set_config "CONFIG_ANDROID_BINDERFS"          "# CONFIG_ANDROID_BINDERFS is not set"

# --- Свобода: devtmpfs, VT, TTY ---
set_config "CONFIG_DEVTMPFS"                  "CONFIG_DEVTMPFS=y"
set_config "CONFIG_DEVTMPFS_MOUNT"            "CONFIG_DEVTMPFS_MOUNT=y"
set_config "CONFIG_VT"                        "CONFIG_VT=y"
set_config "CONFIG_VT_CONSOLE"                "CONFIG_VT_CONSOLE=y"
set_config "CONFIG_VT_HW_CONSOLE_BINDING"     "CONFIG_VT_HW_CONSOLE_BINDING=y"
set_config "CONFIG_DUMMY_CONSOLE"             "CONFIG_DUMMY_CONSOLE=y"
set_config "CONFIG_TTY"                       "CONFIG_TTY=y"
set_config "CONFIG_UNIX98_PTYS"               "CONFIG_UNIX98_PTYS=y"
set_config "CONFIG_LEGACY_PTYS"               "CONFIG_LEGACY_PTYS=y"
set_config "CONFIG_SERIAL_EARLYCON"           "CONFIG_SERIAL_EARLYCON=y"

# --- Полезные штуки для свободного окружения ---
set_config "CONFIG_TMPFS"                     "CONFIG_TMPFS=y"
set_config "CONFIG_TMPFS_POSIX_ACL"           "CONFIG_TMPFS_POSIX_ACL=y"
set_config "CONFIG_PROC_FS"                   "CONFIG_PROC_FS=y"
set_config "CONFIG_SYSFS"                     "CONFIG_SYSFS=y"
set_config "CONFIG_INOTIFY_USER"              "CONFIG_INOTIFY_USER=y"

# debug fs kotak
set_config "CONFIG_MSM_SDE_ROTATOR"              "CONFIG_MSM_SDE_ROTATOR=n"
set_config "CONFIG_DEBUG_FS"                     "CONFIG_DEBUG_FS=n"
set_config "CONFIG_MSM_SDE_ROTATOR_EVTLOG"                     "CONFIG_MSM_SDE_ROTATOR_EVTLOG=n"
set_config "CONFIG_MSM_SDE_ROTATOR_DEBUG"                     "CONFIG_MSM_SDE_ROTATOR_DEBUG=n"

# CONFIG_QCOM_RMTFS_MEM

set_config "CONFIG_UIO_PDRV_GENIRQ"              "CONFIG_UIO_PDRV_GENIRQ=y"
set_config "CONFIG_UIO_DMEM_GENIRQ"              "CONFIG_UIO_DMEM_GENIRQ=y"
set_config "CONFIG_QCOM_RMTFS_MEM"              "CONFIG_QCOM_RMTFS_MEM=y"

set_config "CONFIG_ICNSS2_RESTART_LEVEL_NOTIF" "CONFIG_ICNSS2_RESTART_LEVEL_NOTIF=y"
set_config "CONFIG_DYNAMIC_DEBUG" "CONFIG_DYNAMIC_DEBUG=y"


# ts
set_config "CONFIG_TOUCHSCREEN_FTS" "CONFIG_TOUCHSCREEN_FTS=y"

set_config "CONFIG_CNSS_QCA6750" "CONFIG_CNSS_QCA6750=y"

#usb wifi
set_config "CONFIG_MODULES" "CONFIG_MODULES=y"
set_config "CONFIG_R8188EU" "CONFIG_R8188EU=m"

#-dtbo
set_config "CONFIG_BUILD_ARM64_DT_OVERLAY" "CONFIG_BUILD_ARM64_DT_OVERLAY=n"

./scripts/config --file out/.config --enable RPMSG_QCOM_SMD
./scripts/config --file out/.config --enable QCOM_SYSMON
./scripts/config --file out/.config --enable QCOM_Q6V5_PAS

#usb
# --- USB ECM конфигурация ---
# 1. Вырубаем капризный андроидный Qualcomm GSI
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_CONFIGFS_F_GSI
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_F_GSI

# 2. Выключаем RNDIS (раз он нам не нужен)
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_CONFIGFS_RNDIS
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_F_RNDIS

# 3. Включаем ГЛАВНЫЙ переключатель ECM для ConfigFS
./scripts/config --file "$TARGET_CONFIG" --enable CONFIG_USB_CONFIGFS_ECM

# 4. Включаем сам драйвер функции ECM
./scripts/config --file "$TARGET_CONFIG" --enable CONFIG_USB_F_ECM

# ебаный модем

./scripts/config --file "$TARGET_CONFIG" --enable MSM_PIL_MSS_QDSP6V5


#./scripts/config --file out/.config --enable CONFIG_LTO_CLANG_THIN
#./scripts/config --file out/.config --disable CONFIG_LTO_NONE

./scripts/config --file out/.config --enable CONFIG_LTO_CLANG
./scripts/config --file out/.config --enable CONFIG_LTO_CLANG_THIN
./scripts/config --file out/.config --disable CONFIG_LTO_NONE

./scripts/config --file out/.config --enable CONFIG_CGROUP_DEVICE
./scripts/config --file out/.config --enable CONFIG_CGROUP_PIDS

./scripts/config --file out/.config --disable CNSS_QCA6750



#echo -e 'CONFIG_QCA_CLD_WLAN=m \nCONFIG_QCA_CLD_WLAN_PROFILE="default"' >> out/.config

# Пересчитываем зависимости после патчинга
echo "[KERNEL-BUILD] Resolving config dependencies (olddefconfig)..."
make ARCH=arm64 O=out CC=clang LD=ld.lld LLVM=1 olddefconfig

echo "[KERNEL-BUILD] Config patched successfully!"



# === 5. КОМПИЛЯЦИЯ ===
echo "[KERNEL-BUILD] Compiling..."
#make -j$(nproc) O=out \
#    ARCH=arm64 \
#    CC=clang \
#    CLANG_TRIPLE=aarch64-linux-android- \
#    CROSS_COMPILE=aarch64-linux-android- \
#    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
#    LD=ld.lld \
#    LLVM=1 \
#    LLVM_IAS=1  >/log.txt 2>/log.txt | tee /log.txt

build.sh >/log.txt 2>/log.txt | tee /log.txt

# === 6. РЕЗУЛЬТАТ ===
EXPECTED_IMAGE="out/arch/arm64/boot/Image"
if [ -f "$EXPECTED_IMAGE" ]; then
    echo "===================================================="
    echo "[SUCCESS] Ядро собрано без ограничений!"
    echo "Файл: $ROOT_DIR/$EXPECTED_IMAGE"
    echo "===================================================="
else
    echo "[ERROR] Image не найден после сборки."
    cat /log.txt | grep -E "error:|Error" | tail -20
    exit 1
fi
