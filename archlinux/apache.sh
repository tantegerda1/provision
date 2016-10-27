#!/usr/bin/env bash
#
# Provision testing environment: Install and set up apache webserver
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up apache webserver inside virtual machine
#
main() {

	# see https://wiki.archlinux.org/index.php/Nginx
	if ! pacman --query --quiet --search '^apache$' >/dev/null ; then
		pacman --sync --noconfirm apache

		systemctl enable httpd
		systemctl start httpd
	fi
}





main "$@"
# vim: ts=4
