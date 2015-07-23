# Start Dokku Alternative

## Refs

https://github.com/dokku-alt/dokku-alt

## Start

### on local pc terminal
```
% vagrant up
% vagrant ssh
```

### on vagrant terminal
```
% sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/dokku-alt/dokku-alt/master/bootstrap.sh)"
```

### on local pc browser
access http://192.168.100.10.xip.io:2000/
and set you publick key

# Samples

## node.js
### on local pc terminal
```
% git clone https://github.com/heroku/node-js-sample
% cd node-js-sample
% git remote add dokku dokku@192.168.100.10.xip.io:node-js-app
% git push dokku master
```
access http://node-js-app.192.168.100.10.xip.io/

## FuelPHP
### on local pc terminal
```
% git clone https://github.com/fuel/fuel.git
% cd fuel
% git remote add dokku dokku@192.168.100.10.xip.io:fuel
```
```
% vi .gitignore
-----
diff --git a/.gitignore b/.gitignore
index 19eae45..7dad63d 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,7 +15,7 @@ Thumbs.db
 desktop.ini
 
 # the composer package lock file and install directory
-/composer.lock
+#/composer.lock
 /fuel/vendor
 
 # any of the fuel packages installed by default
```


```
% vi composer.json
-----
diff --git a/composer.json b/composer.json
index 3fa09b0..6354f0b 100644
--- a/composer.json
+++ b/composer.json
@@ -36,6 +36,7 @@
         "mthaml/mthaml": "Allow Haml templating with Twig supports with the Parser package"
     },
     "config": {
+        "bin-dir": "vendor/bin",
         "vendor-dir": "fuel/vendor"
     },
     "extra": {
```
```
% vi Procfile
-----
diff --git a/Procfile b/Procfile
new file mode 100644
index 0000000..48aab52
--- /dev/null
+++ b/Procfile
@@ -0,0 +1 @@
+web: vendor/bin/heroku-php-apache2 public/

```

```
% ./composer.phar install --no-dev --prefer-dist --optimize-autoloader --no-interaction
% git add .gitignore composer.json Procfile composer.lock
% git commit -m “comment”
% git push dokku master
```
access http://fuel.192.168.100.10.xip.io/