#!/usr/bin/env bash
#
# Provision testing environment: Install imagemagick
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Install imagemagick inside virtual machine
#
main() {

	if ! pacman --query --quiet --search '^imagemagick$' >/dev/null ; then
		pacman --sync --noconfirm imagemagick
	fi
}





main "$@"
# vim: ts=4
