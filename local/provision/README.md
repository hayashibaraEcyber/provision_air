# ローカル検証用ansible設定

- CentOS7環境
- Git2.24.x / Ansible2.x だけインストール
- 192.168.33.11

## ベストプラクティスのディレクトリ構成を作成

```
vagrant ssh

cd provion_air
sudo ansible-playbook -i localhost, -c local initializer.yml
```