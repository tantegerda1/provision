#!/usr/bin/env bash
#
# Provision testing environment: php XDebug
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with php XDebug
#
main() {
	local xdebugremotehost="$(ip route | grep default | awk '{ print $3 }')"

	if ! pacman --query --quiet --search '^xdebug$' >/dev/null ; then
		pacman --sync --noconfirm xdebug
	fi


    cat > /etc/php/conf.d/xdebug.ini <<-EOF
		zend_extension=xdebug

		xdebug.idekey = xdebug
		xdebug.max_nesting_level = 500
		xdebug.remote_autostart = on
		xdebug.remote_enable = on
		xdebug.remote_host = ${xdebugremotehost}
	EOF

	systemctl restart php-fpm
}


main "$@"
# vim: ts=4
