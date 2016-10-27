#!/usr/bin/env bash
#
# Provision testing environment: Install and set up mariadb server
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up mariadb server inside virtual machine
#
main() {

	# see https://wiki.archlinux.org/index.php/MySQL
	if ! pacman --query --quiet --search '^mariadb$' >/dev/null ; then
		pacman --sync --noconfirm mariadb

		mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

		systemctl enable mariadb
		systemctl start mariadb

		mysqladmin -u root password 'vagrant'
		mysqladmin -u root -h dev password 'vagrant' --password=vagrant

    cat > '/root/.my.cnf' << EOF
[client]
user=root
password=vagrant
EOF
	fi
}





main "$@"
# vim: ts=4
