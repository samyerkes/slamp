#!/usr/bin/env bash

# Determine if this machine has already been provisioned
# Basically, run everything after this command once, and only once
if [ -f "/var/vagrant_provision" ]; then 
    exit 0
fi

function say {
    printf "\n--------------------------------------------------------\n"
    printf "\t$1"
    printf "\n--------------------------------------------------------\n"
}

#Install Nano
say "Installing Nano"
    yum install nano

# Install Apache
say "Installing Apache and setting it up."
    sudo yum install httpd -y
    sudo service httpd start

# Install mysql
say "Installing MySQL."
    sudo yum install mysql-server -y
    sudo service mysqld start
    sudo service mysqld restart
    mysql -u root mysql <<< "GRANT ALL ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"

say "Installing PHP"
    sudo yum install php php-mysql -y

say "Starting PHP and MYSQL to run automatically"
    sudo chkconfig httpd on
    sudo chkconfig mysqld on

# If you're using a database
#
# db='wp'
#
# say "Creating the database '$db'"
#    mysql -u root -e "create database $db"
#  
# There is a shared 'sql' directory that contained a .sql (database dump) file. 
# This directory is part of the project path, shared with vagrant under the /vagrant path.
# We are populating the msyql database with that file. In this example it's called databasename.sql
#
##say "Populating Database"
##    mysql -u root -D $db < /vagrant/$db.sql

say "Installing PHP Modules"
    # Install php5, libapache2-mod-php5, php5-mysql curl php5-curl
    sudo yum install -y php5 php5-cli php5-common php5-dev php5-imagick php5-imap php5-gd libapache2-mod-php5 php5-mysql php5-curl

# Restart Apache
say "Restarting Apache"
    sudo service httpd restart

# Let this script know not to run again
touch /var/vagrant_provision