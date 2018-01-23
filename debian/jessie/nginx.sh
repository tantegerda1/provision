#!/usr/bin/env bash
#
# Provision testing environment: Install and set up nginx webserver
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Set up nginx webserver inside virtual machine
#
main() {

	apt-get --quiet -o=Dpkg::Use-Pty=0 --assume-yes --no-install-recommends install nginx
	rm --force /etc/nginx/sites-available/default
	rm --force /etc/nginx/sites-enabled/default

	cat > /etc/nginx/conf.d/logformat.conf <<-'EOF'
		log_format  main  '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" ';
		log_format  error403  '$remote_addr - [$time_local] "$request"';
	EOF
	systemctl restart nginx
}





main "$@"
# vim: ts=4
