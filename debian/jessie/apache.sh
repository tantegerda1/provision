#!/usr/bin/env bash
#
# Provision testing environment: Install and set up apache webserver
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up apache webserver inside virtual machine
#
main() {

	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install apache2
	rm --force /etc/apache2/sites-available/default
	rm --force /etc/apache2/sites-enabled/default

	systemctl restart apache2
}





main "$@"
# vim: ts=4
