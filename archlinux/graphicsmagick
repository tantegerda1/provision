#!/usr/bin/env bash
#
# Provision testing environment: Install graphicsmagick
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Install graphicsmagick inside virtual machine
#
main() {

	if ! pacman --query --quiet --search '^graphicsmagick$' >/dev/null ; then
		pacman --sync --noconfirm graphicsmagick
	fi
}





main "$@"
# vim: ts=4
