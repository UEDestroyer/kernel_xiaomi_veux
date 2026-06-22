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

# ts
set_config "CONFIG_TOUCHSCREEN_FTS" "CONFIG_TOUCHSCREEN_FTS=y"


#usb
# Отключаем Qualcomm GSI
# Отключаем Qualcomm GSI, указывая точный путь к конфигу в out/
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_CONFIGFS_F_GSI
./scripts/config --file "$TARGET_CONFIG" --disable CONFIG_USB_F_GSI

# Включем стандартный ванильный RNDIS
./scripts/config --file "$TARGET_CONFIG" --enable CONFIG_USB_F_RNDIS

# Пересчитываем зависимости после патчинга
echo "[KERNEL-BUILD] Resolving config dependencies (olddefconfig)..."
make olddefconfig O=out ARCH=arm64 CC=clang LLVM=1 LLVM_IAS=1

echo "[KERNEL-BUILD] Config patched successfully!"

# === 5. КОМПИЛЯЦИЯ ===
echo "[KERNEL-BUILD] Compiling..."
make -j$(nproc) O=out \
    ARCH=arm64 \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-android- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
    LD=ld.lld \
    LLVM=1 \
    LLVM_IAS=1  >/log.txt 2>/log.txt | tee /log.txt

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
