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

	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install php5-xdebug


    cat > /etc/php5/mods-available/xdebug.ini << EOF
zend_extension=xdebug.so

xdebug.idekey = xdebug
xdebug.max_nesting_level = 400
xdebug.remote_autostart = on
xdebug.remote_enable = on
xdebug.remote_host = ${xdebugremotehost}
EOF


	if dpkg-query -W -f='${Status}' php5-fpm 2>/dev/null | grep -q "ok installed" ; then
		systemctl restart php5-fpm
	fi

	if dpkg-query -W -f='${Status}' libapache2-mod-php5 2>/dev/null | grep -q "ok installed" ; then
		systemctl restart apache2
	fi
}


main "$@"
# vim: ts=4
