#!/usr/bin/env bash
#
# Provision testing environment: Install imagemagick
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up imagemagick inside virtual machine
#
main() {
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install \
		imagemagick
}





main "$@"
# vim: ts=4
