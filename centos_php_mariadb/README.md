centos\_php\_mariadb
===============

CentOS 7.x + Apache Httpd 2.4.x + PHP 7.x + MariaDB 10.x

## Quick Start

Laravelの初期画面が表示されることを確認する。

### 初回

```
$ vagrant up
$ vagrant reload
$ vagrant ssh
vagrant$ cd /sync
vagrant$ composer create-project --prefer-dist laravel/laravel laravel-server
vagrant$ cd laravel-server
vagrant$ cp .env.example .env
vagrant$ php artisan key:generate
vagrant$ '/usr/bin/mysqladmin' -u root password 'root'
vagrant$ echo "create database laravel_server;" | mysql -u root -p
```

### 二回目以降

```
$ vagrant up
```

#### 終了

```
$ vagrant halt
```

### 確認

http://192.168.33.10/public/

Laravelの初期ページが表示されればOK。

## 前提

* macOS 10.13.1
* Vagrant 1.9.4
* VirtaulBox 5.1.30

Vagrantを使うので、コマンドライン作業ができることを想定している。

Windowsでも`Vagrant`と`VirtualBox`をインストールしていれば、問題無いはず。

`Vagrant`にてプラグインを使うので、下記コマンドを事前に実行する。

```
$ vagrant plugin install vagrant-vbguest
```

## 環境情報

### 設定ファイルの調整

#### Xdebug

キー、ポート番号、IPアドレスなど、必要に応じて変更。

*conf/15-xdebug.ini*

```
; Enable xdebug extension module
zend_extension=xdebug.so

xdebug.idekey = ind_devenv_default
xdebug.remote_autostart = 1
xdebug.remote_enable = 1
xdebug.remote_host = 192.168.33.1
xdebug.remote_port = 9900
```

#### mariadb.repo

バージョン調整が必要な場合に、適切なリポジトリに変更。

*conf/mariadb.repo*

```
# MariaDB 10.2 CentOS repository list - created 2017-10-19 05:34 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

#### Apache Httpd

`create-project` したパスにあわせて設定をする。
基本は、`DocumentRoot`、`ErrorLog`、`CustomLog`、`Directory`、のパスが有効なものであれば良い。

*conf/laravel-server.conf*

```
NameVirtualHost *:80

<VirtualHost _default_:80>
        DocumentRoot /sync/laravel-server/public
        ServerName laravel.sv

        ErrorLog /sync/logs/laravel-error_log
        CustomLog /sync/logs/laravel-access_log common
        <Directory  /sync/laravel-server/public >
                # default charset UTF-8
                AddDefaultCharset utf-8

                # .htaccess setting
                AllowOverride All

                # SSI OK
                # SymbolicLink OK
                Options +Includes +FollowSymLinks

                # aapche 2.4 change config
                # Order Deny,Allow
                # Allow from all
                Require all granted

        </Directory>

        <Files ~ "^\.">
                # .ht*
                # .svn*
                # .csv*
                #  etc
                # Deny from all
               # apache 2.4 changed
                Require all denied
        </Files>

        <Files ~ ".*conf.*">
                # config.inc.php
                # ****.conf
                # Deny from all
               # apache 2.4 changed
                Require all denied
        </Files>

        <Files ~ "(\.tmpl|\.tpl|\.vm|\.mayaa|\.properties|\.back|\.bk|~|[0-9]+|build.xml)$">
                # .tmpl  .tpl .vm     : Template Files
                # .mayaa .properties  : Control File
                # .back .bk *~ *n     : Backup File
                # build.xml           : Ant Build Control File
                # Deny from all
               # apache 2.4 changed
                Require all denied
        </Files>
</VirtualHost>
```

#### Google Chrome
Laravel DuskでE2Eテストを実行できるように、Google Chromeをインストールしている。

*conf/google-chrome.repo*

```
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
```

### 仮想環境構築

```
$ vagrant up
$ vagrant reload
$ vagrant ssh
vagrant$ cd /sync
vagrant$ composer create-project --prefer-dist laravel/laravel laravel-server
vagrant$ cd laravel-server
vagrant$ cp .env.example .env
vagrant$ php artisan key:generate
vagrant$ '/usr/bin/mysqladmin' -u root password 'root'
vagrant$ echo "create database laravel_server;" | mysql -u root -p
```

ここでは、VagrantのPluginとして`vagrant-vbguest`を利用している前提とする。

最初の`vagrant up`で、`Vagrant Guest Additions`がインストールされる。
ローカルPCでアプリケーション開発しVagrant内で実行、という今回の環境で必須の作業。
そのまま引き続き、PHPやMariaDBといったミドルウェアのインストールが実施される。

`vagrant reload`で、各種設定の完了した状態で再起動を行なう。
ここでエラー無しで起動できれば、設定は問題なく完了している。

エラーが無いことを確認したら、`vagrant ssh`でVagrant内の仮想環境にログインし、MariaDBのrootユーザーのパスワードの設定と、アプリケーションで利用するDBの作成を実施している。

### 仮想環境構築後の起動手順

```
$ vagrant up
```

### 開発終了時の終了手順

PCの電源を切る前に、Vagrant環境のシャットダウンを実施しておく。

```
$ vagrant halt
```

### 構築後の環境

Vagrantで起動できるVMのIPアドレスは`192.168.33.10`。

#### ssh

```
$ vagrant ssh
```

or

```
$ ssh vagrant@192.168.33.10
password: vagrant
```

#### MariaDB `192.168.33.10:3306`
```
user: root
password: root
```

MySQL Workbenchなどで接続するときは、SSH経由の方が良いと思う。

Laravelからの指定であれば、`localhost`を指定することになる。

DB名は、この手順内では"仮想環境構築"で実施した通り`laravel_server`としている。必要に応じて`.env`ファイルとともに修正すること。

#### Apache Httpd 192.168.33.10:80
```
ServerName: logriza.sv
DocumentRoot: /sync/laravel-server/public
LogDir: /sync/logs
```

開発マシンの`hosts`ファイルに下記追加して、`http://laravel.sv`としてアクセスする。

```
# laravel-server
192.168.33.10 laravel.sv
```

Mac or Linux なら、`/etc/hosts`ファイルを編集する。


#### Postfix 192.168.33.10:25

```
Port: 25
```

Laravelからの指定であれば、`localhost`を指定することになる。
初期状態のため、外部とのメール送受信はしないようにする。

必要な場合には、必ず設定を見直すこと。

#### Xdebug(PHP)

下記は、ローカルPCのIDE側で必要となる設定。

```
Server: 192.168.33.10
Port: 80
Debug port: 9900
Debugger: Xdebug
Key: ind_devenv_default
```

Intellij IDEA系の場合、
`Preferences -> Language&Frameworks -> PHP -> Servers`でサーバを追加しておく。

この時に`Use path mappings`を有効にし、`Project files`の対応パスに`/sync/laravel-server`を設定する。

