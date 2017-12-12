#!/bin/sh

sudo docker run --name fuelphp-app --link fuelphp-mysql:mysql -v /vagrant/fuelphp:/var/www/fuelphp -v /home/vagrant/logs:/var/www/fuelphp/fuel/app/logs --privileged -d -p 8000:80 tacck/fuelphp-app:php-5.6
