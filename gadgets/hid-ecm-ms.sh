#!/bin/bash
#
# Sets up a composite USB device providing Ethernet over USB, HID, and
# Mass Storage capabilities. Code from various unlicensed sources.
#

# load libcomposite
modprobe libcomposite

# remove all USB Ethernet drivers
modprobe -r g_ether usb_f_ecm u_ether

# insert FunctionFS modules for HID, ECM Ethernet, and Mass Storage
# these will provide functions for our USB gadget
modprobe usb_f_hid
modprobe usb_f_ecm
modprobe usb_f_mass_storage

# instantiate a new USB gadget via ConfigFS and cd to it
cd /sys/kernel/config/
mkdir usb_gadget/g1
cd usb_gadget/g1

# create a new configuration for this gadget and add three functions (HID, ECM, MS)
mkdir configs/c.1
mkdir functions/hid.usb0
mkdir functions/ecm.usb0
mkdir functions/mass_storage.ms0

# configure mass storage function by setting path to image to expose as MS filesystem
echo /massstorage.img > functions/mass_storage.ms0/lun.0/file
echo 1 > functions/mass_storage.ms0/lun.0/removable

# configure HID Keyboard; see USB HID Class Specification for details
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne "\x05\x01\x09\x06\xA1\x01\x05\x07\x19\xE0\x29\xE7\x15\x00\x25\x01\x75\x01\x95\x08\x81\x02\x95\x01\x75\x08\x81\x03\x95\x05\x75\x01\x05\x08\x19\x01\x29\x05\x91\x02\x95\x01\x75\x03\x91\x03\x95\x06\x75\x08\x15\x00\x25\x65\x05\x07\x19\x00\x29\x65\x81\x00\xC0" > functions/hid.usb0/report_desc

# configure general properties for this USB device; see USB Specification for details
mkdir strings/0x409
mkdir configs/c.1/strings/0x409
echo 0x1d6b > idVendor                  # Linux Foundation
echo 0x0104 > idProduct                 # Multifunction Composite Gadget
echo 0x0100 > bcdDevice                 # v1.0.0
echo 0x0200 > bcdUSB                    # USB2
echo "deadbeef9876543210" > strings/0x409/serialnumber
echo "USBArmory" > strings/0x409/manufacturer
echo "USBArmory Composite Device" > strings/0x409/product

# name this configuration
echo "Conf1" > configs/c.1/strings/0x409/configuration
echo 120 > configs/c.1/MaxPower


# bind all functions provided by FunctionFS to our configuration
ln -s functions/hid.usb0 configs/c.1/
ln -s functions/ecm.usb0 configs/c.1/
ln -s functions/mass_storage.ms0 configs/c.1/

# bind USBG driver
echo ci_hdrc.0 > UDC
