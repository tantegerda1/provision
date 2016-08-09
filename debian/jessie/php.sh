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


	if grep --extended-regex --quiet '^;?include=/etc/php5/fpm/\*.conf$' /etc/php5/fpm/php-fpm.conf ; then
		sed --regexp-extended --in-place 's@^;?include=/etc/php5/fpm/*.conf@include=/etc/php5/fpm/*.conf@' /etc/php5/fpm/php-fpm.conf
	else
		echo 'include=/etc/php5/fpm/*.conf' >> /etc/php5/fpm/php-fpm.conf
	fi

	cat > /etc/php5/fpm/conf.d/30-log.ini << EOF
error_log = /var/log/php-fpm/error.log
log_errors = on
EOF

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

	mkdir --parents /var/log/php-fpm/
	touch /var/log/php-fpm/error.log
	chown --recursive www-data:adm /var/log/php-fpm
	chmod 755 /var/log/php-fpm
	chmod 644 /var/log/php-fpm/error.log
	systemctl restart php5-fpm
}


main "$@"
# vim: ts=4
