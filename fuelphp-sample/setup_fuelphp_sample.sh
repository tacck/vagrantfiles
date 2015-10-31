#!/bin/sh

wget -O fuelphp-1.7.3.zip http://fuelphp.com/files/download/34
unzip fuelphp-1.7.3.zip
mv fuelphp-1.7.3 fuelphp
cp -R sample/fuelphp/ fuelphp
