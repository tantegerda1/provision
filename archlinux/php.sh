#!/usr/bin/env bash
#
# Provision testing environment: Install and set up php (cli and php-fpm)
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with php (cli and php-fpm)
#
main() {
	if ! pacman --query --quiet --search '^php(-fpm|-gd|-tidy)$' >/dev/null ; then
		pacman --sync --noconfirm php php-fpm php-gd php-tidy
		systemctl enable php-fpm
	fi

	if grep --extended-regex --quiet '^;?access.log *=.*$' /etc/php/php-fpm.d/www.conf ; then
		sed --regexp-extended --in-place 's@^;?access.log *=.*@access.log = /var/log/php/access.log@' /etc/php/php-fpm.d/www.conf
	else
		echo 'access.log = /var/log/php/access.log' >> /etc/php/php-fpm.d/www.conf
	fi
	
	if grep --extended-regex --quiet '^;?clear_env *=.*$' /etc/php/php-fpm.d/www.conf ; then
		sed --regexp-extended --in-place 's@^;?clear_env *=.*@clear_env = no@' /etc/php/php-fpm.d/www.conf
	else
		echo 'clear_env = no' >> /etc/php/php-fpm.d/www.conf
	fi


	cat > /etc/php/conf.d/log.ini <<EOF
log_errors = on
error_log = /var/log/php/error.log
EOF

	cat > /etc/php/conf.d/limits.ini <<EOF
max_execution_time = 240
max_input_vars = 1500
EOF

	cat > /etc/php/conf.d/extensions.ini <<EOF
extension=bz2.so
extension=exif.so
extension=gd.so
extension=iconv.so
extension=mysqli.so
extension=pdo_mysql.so
extension=soap.so
extension=tidy.so

zend_extension=opcache.so
EOF


	mkdir --parents /etc/systemd/system/php-fpm.service.d/
	cat > /etc/systemd/system/php-fpm.service.d/environment_php-fpm.conf <<EOF
[Service]
EnvironmentFile=/etc/environment
EOF
	systemctl daemon-reload


	mkdir --parents /var/log/php/
	chown --recursive http:adm /var/log/php
	chmod 775 /var/log/php
	systemctl restart php-fpm
}


main "$@"
# vim: ts=4
