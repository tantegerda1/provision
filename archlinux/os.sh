#!/usr/bin/env bash
#
# Provision testing environment: Basic debian setup
#
# Ludwig Rafelsberger <info@netztechniker.at>
#


#
# Set up this virtual machine
#
# $1 - primary hostname
# $2 - all hostnames (space separated)
#
main() {
	hostname="$1"; shift
	all_hostnames="$1"; shift

	yaourt -Syuad --noconfirm
	rm /var/cache/pacman/pkg/*.xz

	# see https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname
	hostnamectl set-hostname "${hostname}"
	hostname "${hostname}"
	sed -i "1c\\127.0.0.1	${all_hostnames}" /etc/hosts


	# see https://wiki.archlinux.org/index.php/Locale
	cat > /etc/locale.gen <<EOF
de_AT.UTF-8 UTF-8
EOF
	locale-gen
	localectl set-locale LANG='de_AT.utf-8'
	localectl set-locale LC_COLLATE='de_AT.utf-8'

	# see https://wiki.archlinux.org/index.php/Time#Time_zone
	timedatectl set-timezone Europe/Vienna

	# https://wiki.archlinux.org/index.php/Environment_variables
	touch /etc/environment
	if ! grep -q 'HOSTING="vagrant"' /etc/environment ; then
		echo 'HOSTING="vagrant"' >> /etc/environment
		source /etc/environment
	fi
	cat > /etc/sudoers.d/environment <<EOF
Defaults env_keep += "HOSTING"
EOF
	chown root:root /etc/sudoers.d/environment
	chmod 0440 /etc/sudoers.d/environment
}



main "$@"
# vim: ts=4
