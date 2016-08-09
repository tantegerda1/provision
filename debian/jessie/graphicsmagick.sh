#!/usr/bin/env bash
#
# Provision testing environment: Install graphicsmagick
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up graphicsmagick inside virtual machine
#
main() {
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install \
		graphicsmagick
}





main "$@"
# vim: ts=4
