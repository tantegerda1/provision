#!/usr/bin/env bash
#
# Provision testing environment: Configure databases and access to them
#
# Ludwig Rafelsberger <info@netztechniker.at>



#
# Configure databases and access to them
#
main() {
    mysql -u root --password=vagrant <<EOF
CREATE database IF NOT EXISTS \`dev\` CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost' IDENTIFIED BY 'dev';
FLUSH PRIVILEGES;
EOF

    cat > '/home/vagrant/.my.cnf' << EOF
[client]
database=dev
user=dev
password=dev
EOF
    chown vagrant:vagrant /home/vagrant/.my.cnf
    chmod 600 /home/vagrant/.my.cnf
}





main "$@"
# vim: ts=4
