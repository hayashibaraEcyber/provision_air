# provision_air

air_cms/公開サーバーの環境を作成します

# 本番環境へのデプロイ
### 必要なソフトのインストール

事前にローカルPC(Windows10マシンを想定)に、以下のソフトウェアをインストールしておく

- VirtualBox
    - https://www.oracle.com/jp/virtualization/technologies/vm/downloads/virtualbox-downloads.html
- Vagrant
    - https://www.vagrantup.com/
- WinSCP
    - https://forest.watch.impress.co.jp/library/software/winscp/
- Gitクライアント
    - VSCode, SourceTree 等

### リポジトリのチェックアウト

このリポジトリをチェックアウトする

provision_airディレクトリを、以降 **(HOME)** とする

### 実行環境を立ち上げる

**(HOME)** 以下の local/provision に移動
コマンドラインで以下を実行

```
vagrant up --provision
```

AnsibleとGitがインストールされたCentOS7が立ち上がる
ip: 192.168.33.11
name: vagrant
pass: vagrant

sshでログインする

```
cd /home/vagrant/
git clone https://github.com/hayashibaraEcyber/provision_air.git
```

192.168.33.11 /home/vagrant/ を 以下 **(実行環境)** とする

### テストサーバーをを立ち上げる

**(HOME)** 以下の local/server に移動
コマンドラインで以下を実行

```
vagrant up --provision
```

CentOS7が立ち上がる
ip: 192.168.33.12
name: vagrant
pass: vagrant

### 公開鍵/秘密鍵を作成

[PuTTYgen を利用してRSAキーペアを作成する](https://www.ipentec.com/document/windows-create-rsa-keypair-using-puttygen)

公開鍵を "Save public key" で 今回は `cypochi-hospital.pub` で保存する。

秘密鍵を 上部メニュー"Conversions" から "Export OpenSSH key (force new file format)" を選び、今回は   `cypochi-hospital.pem` で保存する。

WinSCPを使用し、**(実行環境)**に、公開鍵 `cypochi-hospital.pub` を転送する

### 公開鍵を変換

**(実行環境)** で以下実行

```
cd /home/vagrant/
sudo ssh-keygen -i -f cypochi-hospital.pub > provision_air/centos7/roles/common/files/id_rsa.pub
ls -ltr provision_air/centos7/roles/common/files/id_rsa.pub
```

### インベントリファイルを編集

**(実行環境)** で以下実行

```
cd /home/vagrant/
cp provision_air/centos7/develop provision_air/centos7/production
vi provision_air/centos7/production
```

`provision_air/centos7/production` をコメントにしたがって書き換える

### テスト実行

**(実行環境)** で以下実行

```
cd /home/vagrant/provision_air/centos7/
sudo ansible-playbook -i develp web.yml -u vagrant --ask-pass --ask-become-pass
```

文法チェックと、設定が走りきることを確認

### プロビジョン実行

**(実行環境)** で以下実行

```
cd /home/vagrant/provision_air/centos7/
sudo ansible-playbook -i production web.yml -u root --ask-pass --ask-become-pass
```
