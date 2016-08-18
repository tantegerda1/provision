#!/usr/bin/env bash
#
# Provision testing environment: Install and set up php (cli and apache module)
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with php (cli and apache module)
#
main() {
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install libapache2-mod-php5 php5-gd php5-mysqlnd php5-curl php5-mcrypt


	mkdir -p /etc/php5/conf-available
	cat > /etc/php5/conf-available/log.ini << EOF
log_errors = on
error_log = /var/log/php/error.log
EOF
	ln --force --symbolic ../../conf-available/log.ini /etc/php5/cli/conf.d/30-log.ini

	mkdir --parents /var/log/php/
	chown --recursive www-data:adm /var/log/php
	chmod 775 /var/log/php
}


main "$@"
# vim: ts=4
