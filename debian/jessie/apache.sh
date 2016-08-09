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
	rm --force /etc/apache2/sites-available/000-default.conf
	rm --force /etc/apache2/sites-available/default-ssl.conf
	rm --force /etc/apache2/sites-enabled/000-default.conf

	systemctl restart apache2
}





main "$@"
# vim: ts=4
