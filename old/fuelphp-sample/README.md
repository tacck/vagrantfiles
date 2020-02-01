# Docker上でFuelPHP + MySQLの開発環境を構築

## 環境
| 要素 | Version | 参考 |
|:------|:---|:---|
| Mac OSX |  |  |
| Vagrant | 1.7.4 | |
| VirtualBox | 5.0.4 | |
| CentOS (on Vagrant) | 7 | https://atlas.hashicorp.com/centos/boxes/7 |
| Docker (on CentOS) |  |  |
| PHP (on Docker) | 5.6 | https://hub.docker.com/_/php/ |
| MySQL (on Docker) | 5.7 | https://hub.docker.com/_/mysql/ |



## 実行

### FuelPHP

wget -O fuelphp-1.7.3.zip http://fuelphp.com/files/download/34
unzip fuelphp-1.7.3.zip

### FuelPHP SampleCode

See: sample/

### CentOS

#### Vagrantfile

boxは、公式に登録されている`centos/7`を利用。

vagrant環境内でのディレクトリ共有が行なわれなかったので、明示的に記述。
`config.vm.synced_folder ".", "/vagrant", disabled: false, owner: "root", group: "root"`

Dockder環境のphpから、`/vagrant/`配下のファイル操作が上手くいかずにlogsへのファイル書き出しができない。
そのために、ログは/home/vagrant/logsに書き込むようにdocker側で対応が必要。
こちらでディレクトリの作成と権限変更を行なっておく。

`centos/7`は、VirtualBox Guest Additionsが未インストール。
自動で対応してくれるプラグインをインストールしてから、`vagrant up`の実行。

```
% vagrant plugin install vagrant-vbguest
% vagrant up
```



## 上記を行なうスクリプトなど

```
% git clone https://github.com/tacck/vagrantfiles.git
% cd fuelphp-sample
% ./setup_fuelphp_sample.sh
% vagrant up
```