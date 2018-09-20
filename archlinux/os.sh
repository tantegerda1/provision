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

	if ! pacman --query --quiet --search '^reflector$' >/dev/null ; then
		pacman --sync --noconfirm reflector
	fi
	reflector --age 4 --fastest 64 --latest 32 --number 16 --sort rate --save /etc/pacman.d/mirrorlist

	pacman -Syud --noconfirm
	
	if ! pacman --query --quiet --search '^pacman-contrib$' >/dev/null ; then
		pacman --sync --noconfirm pacman-contrib
	fi
	paccache -rk0

	# see https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname
	hostnamectl set-hostname "${hostname}"
	hostname "${hostname}"
	sed -i "1c\\127.0.0.1	${all_hostnames}" /etc/hosts


	# see https://wiki.archlinux.org/index.php/Locale
	cat > /etc/locale.gen <<-'EOF'
		de_AT.UTF-8 UTF-8
		de_DE.UTF-8 UTF-8
		en_GB.UTF-8 UTF-8
		en_US.UTF-8 UTF-8
		es_ES.UTF-8 UTF-8
		fr_FR.UTF-8 UTF-8
		pt_PT.UTF-8 UTF-8
		de_AT UTF-8
		de_DE UTF-8
		en_GB UTF-8
		en_US UTF-8
		es_ES UTF-8
		fr_FR UTF-8
		pt_PT UTF-8
		de_AT.ISO-8859-1 ISO-8859-1
		de_DE.ISO-8859-1 ISO-8859-1
		en_GB.ISO-8859-1 ISO-8859-1
		en_US.ISO-8859-1 ISO-8859-1
		es_ES.ISO-8859-1 ISO-8859-1
		fr_FR.ISO-8859-1 ISO-8859-1
		pt_PT.ISO-8859-1 ISO-8859-1
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
	cat > /etc/sudoers.d/environment <<-'EOF'
		Defaults env_keep += "HOSTING"
	EOF
	chown root:root /etc/sudoers.d/environment
	chmod 0440 /etc/sudoers.d/environment

	echo 'export HOSTING="vagrant"' >> /etc/profile.d/environment.sh
	chmod +x /etc/profile.d/environment.sh
}



main "$@"
# vim: ts=4
