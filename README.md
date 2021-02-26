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
cd provision_air/centos7
pwd
```

192.168.33.11 /home/vagrant/provision_air を 以下 **(実行環境)** とする