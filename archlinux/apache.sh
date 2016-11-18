#!/usr/bin/env bash
#
# Provision testing environment: Install and set up apache webserver
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up apache webserver inside virtual machine
#
main() {
	mkdir --parents /etc/systemd/system/httpd.service.d/
	cat > /etc/systemd/system/httpd.service.d/environment_httpd.conf <<EOF
[Service]
EnvironmentFile=/etc/environment
EOF
	systemctl daemon-reload

	# see https://wiki.archlinux.org/index.php/Apache_HTTP_Server
	if ! pacman --query --quiet --search '^apache$' >/dev/null ; then
		pacman --sync --noconfirm apache

		systemctl enable httpd
		systemctl start httpd
	fi

	# enable rewrite module
	if grep --extended-regex --quiet '^#?LoadModule rewrite_module modules/mod_rewrite.so$' /etc/httpd/conf/httpd.conf ; then
		sed --regexp-extended --in-place 's@#?LoadModule rewrite_module modules/mod_rewrite.so@LoadModule rewrite_module modules/mod_rewrite.so@' /etc/httpd/conf/httpd.conf
	else
		echo 'LoadModule rewrite_module modules/mod_rewrite.so' >> /etc/httpd/conf/httpd.conf
	fi
}





main "$@"
# vim: ts=4
