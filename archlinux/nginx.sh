#!/usr/bin/env bash
#
# Provision testing environment: Install and set up nginx webserver
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up nginx webserver inside virtual machine
#
main() {

	# see https://wiki.archlinux.org/index.php/Nginx
	if ! pacman --query --quiet --search '^nginx-mainline$' >/dev/null ; then
		pacman --sync --noconfirm nginx-mainline

		systemctl enable nginx
		systemctl start nginx
	fi
}





main "$@"
# vim: ts=4
