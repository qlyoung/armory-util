USBArmory host interface configuration files for use with systemd
and systemd-networkd.

10-usbarmory.link
-----------------
This is a rule that sets the name of the USBArmory link interface.
It matches on the MAC address of the USBArmory (1a:55:89:a2:69:42)
and sets the interface name to usbarmory0. Place or symlink it into
/etc/systemd/network and reload with `$ systemctl daemon-reload`.
When you next plug in your USBArmory, instead of enp0s21u1 or usb0
or what have you, the interface will be named usbarmory0 (check with
`$ ip link`). Note that this will *only* work if the MAC address is
the same as above (this is the default MAC on the Debian Jessie base
image provided by Inverse Path). You do not need to be using
systemd-networkd to use this rule, as systemd manages interface
naming with or without it.

10-usbarmory.nework
-------------------
This is a rule that configures the USBArmory with an IP address,
enables kernel IP forwarding and configures IP masquerading.It
matches on the interface name `usbarmory0` or the MAC address
(1a:55:89:a2:69:42), which is the default when using the Debian
Jessie base image provided by Inverse Path. Place or symlink
10-usbarmory.network into /etc/systemd/network/ and reload with
`$ systemctl reload systemd-networkd.service`.

When you next plug in your USBArmory, the interface will be configured
with IP address 10.0.0.2/24 and default gateway 0.0.0.0.

Background:
https://github.com/inversepath/usbarmory/wiki/Host-communication.
