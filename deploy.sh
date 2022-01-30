#!/bin/sh
set -ex

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}


SECURITY_GROUP="sg-043710d377121b44c" #セキュリティグループのID
IP=`curl -s ifconfig.me`  # 現在起動しているコンテナのIPアドレスを代入

# コンテナのIPアドレスからのsshをauthorize(許可する)
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32

# trap "aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32" 0 1 2 3 15
bundle exec cap production deploy
# 許可した設定をrevoke(取り消す)
aws ec2 revoke-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port 22 --cidr ${IP}/32