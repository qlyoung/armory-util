usbarmory.conf
--------------
interfaces rule to configure the USBArmory with a static IP.

Place or symlink usbarmory.conf into /etc/network/interfaces.d/
and source it in your /etc/network/interfaces, like so:

source /etc/network/interfaces.d/usbarmory.conf

The next time your USBArmory is plugged in, the interface will be
with static IP 10.0.0.2/24 and gateway 0.0.0.0. This configuration
assumes the interface will be named `usbarmory0`; this can be
accomplished with the `10-usbarmory.link` file located under `systemd/`
in this repo (if you are using systemd). Otherwise change the interface
name to match name your system assigns.

IP forwarding and masquerading will not be enabled automatically.
You must turn on IP forwarding and apply the iptables rules listed
in the Host Communication page on the USBArmory wiki if you wish
to access the internet from the USBArmory. Commands to do this can
be found in `armory-ip.sh`. Why use this instead of just using that
shell script? Well, it seems that the kernel likes to randomly drop
the IP assignment for the USBArmory if you manually set it with
`$ ip addr add`.

If you are using systemd-networkd to configure the USBArmory you
don't need this file.

Background:
https://github.com/inversepath/usbarmory/wiki/Host-communication.
