server "qjitsu-web", :app, :web, :db, :primary => true
set :deploy_to, "/var/www/#{application}"
set :branch, "master"
set :rails_env, "production"
