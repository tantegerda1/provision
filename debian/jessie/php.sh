#!/usr/bin/env bash
#
# Provision testing environment: Install and set up php (cli and php-fpm)
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with php (cli and php-fpm)
#
main() {
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install php5-fpm php5-gd php5-mysqlnd php5-curl php5-mcrypt

	if grep --extended-regex --quiet '^;?error_log ?=.*$' /etc/php5/fpm/php-fpm.conf ; then
		sed --regexp-extended --in-place 's@^;?error_log ?=.*@error_log = syslog@' /etc/php5/fpm/php-fpm.conf
	else
		echo 'error_log = syslog' >> /etc/php5/fpm/php-fpm.conf
	fi


	if grep --extended-regex --quiet '^;?access.log *=.*$' /etc/php5/fpm/pool.d/www.conf ; then
		sed --regexp-extended --in-place 's@^;?access.log *=.*@access.log = /var/log/php/access.log@' /etc/php5/fpm/pool.d/www.conf
	else
		echo 'access.log = /var/log/php/access.log' >> /etc/php5/fpm/pool.d/www.conf
	fi


	mkdir -p /etc/php5/conf-available
	cat > /etc/php5/conf-available/log.ini << EOF
log_errors = on
error_log = /var/log/php/error.log
EOF
	ln --force --symbolic ../../conf-available/log.ini /etc/php5/cli/conf.d/30-log.ini
	ln --force --symbolic ../../conf-available/log.ini /etc/php5/fpm/conf.d/30-log.ini

	cat > /etc/php5/conf-available/limits.ini << EOF
max_execution_time = 240
max_input_vars = 1500
EOF
	ln --force --symbolic ../../conf-available/limits.ini /etc/php5/cli/conf.d/30-limits.ini
	ln --force --symbolic ../../conf-available/limits.ini /etc/php5/fpm/conf.d/30-limits.ini


	cat > /etc/php5/fpm/pool.d/www-changes.conf << EOF
[www]
clear_env = no
EOF


	mkdir --parents /etc/systemd/system/php5-fpm.service.d/
	cat > /etc/systemd/system/php5-fpm.service.d/environment_php5-fpm.conf << EOF
[Service]
EnvironmentFile=/etc/environment
EOF
	systemctl daemon-reload


	rm --force /var/log/php5-fpm.log
	mkdir --parents /var/log/php/
	chown --recursive www-data:adm /var/log/php
	chmod 775 /var/log/php
	systemctl restart php5-fpm
}


main "$@"
# vim: ts=4
