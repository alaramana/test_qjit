server "qjitsu-web-qa", :app, :web, :db, :primary => true
set :deploy_to, "/var/www/#{application}-qa"
set :branch, "develop"
set :rails_env, "qa"
