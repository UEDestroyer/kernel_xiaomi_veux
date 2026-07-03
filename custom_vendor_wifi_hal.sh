#!/system/bin/sh

# Function to check if a file exists
check_file() {
    if [ ! -e "$1" ]; then
        echo "File not found: $1"
        exit 1
    fi
}

# Function to start vendor.qti.wifi.hal service using systemctl
start_vendor_wifi_hal() {
    # Assuming the service is managed by systemd
    check_file "/etc/systemd/system/vendor.qti.wifi.hal.service"
    systemctl start vendor.qti.wifi.hal.service
}

# Start vendor.qti.wifi.hal service using systemctl
start_vendor_wifi_hal

exit 0
