#!/usr/bin/env bash
#
# Provision testing environment: Install and set up php (cli and php-fpm)
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with redis (server and php module)
#
main() {
	if ! pacman --query --quiet --search '^redis$' >/dev/null ; then
		pacman --sync --noconfirm redis
		systemctl enable redis
		systemctl start redis
	fi

	if ! yaourt --query --quiet --search '^php-redis$' >/dev/null ; then
		yaourt --sync --noconfirm php-redis
	fi

	cat > /etc/php/conf.d/redis.ini <<-EOF
		extension=redis.so
	EOF


	systemctl restart php-fpm
}


main "$@"
# vim: ts=4
