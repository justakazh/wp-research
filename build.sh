#installing depedences
apt update
apt install -y apache2 php mariadb-server
apt install -y nano curl unzip wget php-curl libapache2-mod-php php-mysql php-common

#starting service
service apache2 start
service mariadb start

#configure apache2 
rm /etc/apache2/sites-available/000-default.conf
cp apache_conf/000-default.conf /etc/apache2/sites-available/000-default.conf
cp apache_conf/apache2.conf /etc/apache2/apache2.conf
a2enmod rewrite
service apache2 restart



#configure wordpress
rm -fr /var/www/html
rm -fr /var/www/backup || true #if any 
cp -r ./wordpress /var/www/html
cp -r ./wordpress /var/www/backup
chmod +x wp-start
chmod +x wp-refresh
cp wp-start /usr/bin/wp-start
cp wp-refresh /usr/bin/wp-refresh
chmod 777 -R /var/www/


#configure mysql
mysql -u root -p' ' --execute "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';FLUSH PRIVILEGES;"
mysql -u admin -p'password' --execute 'drop database wp;' || true #if any
mysql -u admin -p'password' --execute 'create database wp;'
mysql -u admin -p'password' wp < /var/www/backup/wp.sql


#start 
wp-start
