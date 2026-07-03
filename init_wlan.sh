#!/system/bin/sh

# Function to check if a file exists
check_file() {
    if [ ! -e "$1" ]; then
        echo "File not found: $1"
        exit 1
    fi
}

# Function to kick GPIO/Power-regulator for WCNSS
kick_wcnss_power() {
    # Assuming the GPIO/Power-regulator is controlled via /sys/class/gpio/gpioX/value
    check_file "/sys/class/gpio/gpioX/value"
    echo "1" > /sys/class/gpio/gpioX/value
    sleep 0.5
    echo "0" > /sys/class/gpio/gpioX/value
}

# Function to start custom vendor.qti.wifi.hal daemon
start_custom_vendor_wifi_hal() {
    # Assuming the custom daemon script is located at /system/bin/custom_vendor_wifi_hal.sh
    check_file "/system/bin/custom_vendor_wifi_hal.sh"
    /system/bin/custom_vendor_wifi_hal.sh
}

# Function to start wpa_supplicant
start_wpa_supplicant() {
    # Assuming wpa_supplicant is managed by init.rc or similar
    check_file "/system/bin/wpa_supplicant"
    setprop ctl.start wpa_supplicant
}

# Check if WLAN-Subsystem is already up
if [ -e "/sys/class/net/wlan0" ]; then
    echo "WLAN is already up."
    exit 0
fi

# Kick GPIO/Power-regulator for WCNSS
kick_wcnss_power

# Start custom vendor.qti.wifi.hal daemon
start_custom_vendor_wifi_hal

# Start wpa_supplicant
start_wpa_supplicant

# Check if WLAN-Subsystem is now up
if [ -e "/sys/class/net/wlan0" ]; then
    echo "WLAN has been successfully initialized."
else
    echo "Failed to initialize WLAN. Please check logs for errors."
    exit 1
fi
