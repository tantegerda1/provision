#!/usr/bin/env bash
#
# Provision testing environment: Install and set up redis and the redis php module
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine with redis (server and php module)
#
main() {
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install redis-server php5-redis

	if grep --extended-regex --quiet '^databases .*$' /etc/redis/redis.conf ; then
		sed --regexp-extended --in-place 's@^databases .*@databases 64@' /etc/redis/redis.conf
	else
		echo 'databases 64' >> /etc/redis/redis.conf
	fi
	systemctl restart redis-server
}


main "$@"
# vim: ts=4
