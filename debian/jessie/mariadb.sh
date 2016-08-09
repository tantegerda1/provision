#!/usr/bin/env bash
#
# Provision testing environment: Install and set up mariadb server
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up mariadb server inside virtual machine
#
main() {
	echo 'mysql-server mysql-server/root_password password vagrant' | debconf-set-selections
	echo 'mysql-server mysql-server/root_password_again password vagrant' | debconf-set-selections

	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install \
		mariadb-server mariadb-client
}





main "$@"
# vim: ts=4
