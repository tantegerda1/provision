#!/usr/bin/env bash
#
# Provision testing environment: Install virtualbox guest utils
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Install virtualbox guest utils inside virtual machine
#
main() {
	cat > /etc/apt/sources.list.d/debian-contrib.list << EOF
# contrib and non-free packages
deb http://httpredir.debian.org/debian stable main contrib non-free
EOF
    apt-get --quiet -o=Dpkg::Use-Pty=0 update
    apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install virtualbox-guest-utils
}





main "$@"
# vim: ts=4
