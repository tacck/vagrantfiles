#!/bin/sh

sudo docker run --volumes-from fuelphp-mysql-data --name fuelphp-mysql -e MYSQL_DATABASE=fuel_sample -e MYSQL_ROOT_PASSWORD=sample -p 3306:3306 -d tacck/fuelphp-mysql:mysql-5.7
