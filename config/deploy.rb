# config valid only for current version of Capistrano
# capistranoのバージョンを記載。固定のバージョンを利用し続け、バージョン変更によるトラブルを防止する
lock '3.16.0'

# Capistranoのログの表示に利用する
set :application, 'portfolio_app'
set :deploy_to, '/var/www/portfolio_app'

# どのリポジトリからアプリをpullするかを指定する
set :repo_url,  'git@github.com:YusukeSakuraba/portfolio_app.git'

# バージョンが変わっても共通で参照するディレクトリを指定
set :linked_dirs,
    fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system',
                                 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '3.0.2'

# どの公開鍵を利用してデプロイするか
set :ssh_options, auth_methods: ['publickey'],
                  keys: ['~/.ssh/id_rsa']

# プロセス番号を記載したファイルの場所
set :puma_pid, -> { "#{shared_path}/tmp/pids/puma.pid" }

# pumaの設定ファイルの場所
set :puma_config_path, -> { "#{current_path}/config/puma.rb" }
set :keep_releases, 5

# デプロイ処理が終わった後、pumaを再起動するための記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'puma:restart'
  end
end
