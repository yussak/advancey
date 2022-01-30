#!/bin/sh
set -ex


SECURITY_GROUP="sg-0980635bb414c35d3" #セキュリティグループのID
IP=`curl -s ifconfig.me`  # 現在起動しているコンテナのIPアドレスを代入
sudo ntpdate -v ntp.nict.jp

# コンテナのIPアドレスからのsshをauthorize(許可する)
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32
bundle exec cap production deploy
# 許可した設定をrevoke(取り消す)
aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32