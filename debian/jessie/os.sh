#!/usr/bin/env bash
#
# Provision testing environment: Basic debian setup
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up this virtual machine
#
# $1 - primary hostname
# $2 - all hostnames (space separated)
#
main() {
	hostname="$1"; shift
	all_hostnames="$1"; shift

	export DEBIAN_FRONTEND=noninteractive

	echo 'locales	locales/default_environment_locale	select	de_AT.UTF-8' | debconf-set-selections
	echo 'locales	locales/locales_to_be_generated	multiselect	de_AT.UTF-8 UTF-8' | debconf-set-selections
	echo -e "de_AT.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" > /etc/locale.gen
	dpkg-reconfigure locales
	localectl set-locale LANG="de_AT.utf-8"
	localectl set-locale LC_COLLATE="de_AT.utf-8"


	hostnamectl set-hostname "${hostname}"
	sed -i "1c\\127.0.0.1	${all_hostnames}" /etc/hosts

	timedatectl set-timezone Europe/Berlin

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

	install_packages
}


#
# Install base packages
#
install_packages() {

	# sync package list, update preinstalled packages
	apt-get --quiet -o=Dpkg::Use-Pty=0 update
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes upgrade
	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install \
		curl wget \
		vim
}




main "$@"
# vim: ts=4
