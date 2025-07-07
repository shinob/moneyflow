#!/bin/bash

# スクリプトのディレクトリに移動
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

# Gemをインストール
bundle install

# Sinatraアプリケーションを起動
#bundle exec rackup -p 4567
bundle exec puma -b 'tcp://0.0.0.0:9291' -b 'tcp://[::]:9292'
