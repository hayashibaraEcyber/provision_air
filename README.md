# provision_air

## ベストプラクティスのディレクトリ構成を作成

```
sudo ansible-playbook -i localhost, -c local initializer.yml
```

## develop dry run

```
cd centos7
sudo ansible-playbook -i develop cms.yml -u vagrant --ask-pass --ask-become-pass --check
```