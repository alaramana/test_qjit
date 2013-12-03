# Capistrano Deploy Recipe for Git and Phusion Passenger
#


# gem install backup
# backup generate:model --trigger backup --databases='postgresql' --no-splitter --storages='local' --config-path='./Backup'

# su postgres

# login as postgres
# createuser tobi(substitute with your username)
#    Shall the new role be a superuser? (y/n) n
#    Shall the new role be allowed to create databases? (y/n) y
#    Shall the new role be allowed to create more new roles? (y/n) n

# su postgres -c psql

# su postgres -c psql
# postgres=# create database vh_drawmd_website_staging;
# postgres=# GRANT ALL ON DATABASE vh_drawmd_website_staging to vh_drawmd_website_staging_user;

# After issuing cap deploy:setup:
#    -> Place server specific config files in the shared directory

# Set :config_files variable to specify config files that should be
#   copied to config/ directory (i.e. database.yml)
#
# To deploy to staging server:
#  => cap deploy
#  => Deploys application to /home/#{user}/site/staging from master branch
#
# To deploy to production server:
#  =>  cap deploy DEPLOY=PRODUCTION
#  => Deploys application to /home/#{user}/site/production from production branch

### CONFIG: Change ALL of following

set :application, "qjitsu-web"
set :config_files, %w( database.yml )
set :listen_to, "qjitsu.com"

set :repository, "git@github.com:qjitsu/#{application}.git"


#set :sudo, 'env rvmsudo_secure_path=1 rvmsudo'

###################################


# System Options
set :user, "rails"
set :rvm_ruby_string, '1.9.3-p392'
set :rvm_type, :user
set :bundle_without,  [:development]


set :use_sudo, false
default_run_options[:pty] = true
set :keep_releases, 5
ssh_options[:forward_agent] = true

set :stages, ["qa", "production"]
set :default_stage, "qa"


require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'

# Git Options
set :scm, :git
#set :deploy_via, :remote_cache
set :scm_verbose, true



namespace :passenger do   
    desc "Restarts Passenger"
    task :restart do
        puts "\n\n=== Restarting Passenger! ===\n\n"
        run "touch #{release_path}/tmp/restart.txt"
    end
end


namespace :bundle do    
    desc "run bundle install and ensure all gem requirements are met"
    task :install do
        run "cd #{release_path} && bundle install  --deployment --without=test"# --no-update-sources"
    end
end

namespace :apache do  
    desc "Restarts Apache2."
    task :restart do
        run "sudo /etc/init.d/apache2 restart"
    end
end

namespace :deploy do
    desc "Create links to password files"
    task :link_config do
        puts "\n\n== Linking passwords and other environemnt specific settings files"
        run "ln -s -f #{shared_path}/passwords/smtp.yaml #{release_path}/config/smtp.yaml"
    end

    desc "Take control of shared folders"
    task :own_assets do
        puts "\n\n== Setting Ownership for Group on Shared Assets! ===\n\n"
        run "sudo /bin/chmod -R g+w #{shared_path}/assets"
        run "sudo /bin/chmod -R g+w #{shared_path}/cached-copy"
        run "sudo /bin/chown rails:www-data #{deploy_to}"
    end
    
    desc "Release control of files back to www-data"
    task :release_assets do
        puts "\n\n== Release ownership of assets to www-data! ===\n\n"
        run "sudo /bin/chmod -R g-w #{shared_path}/assets"
        run "sudo /bin/chmod -R g-w #{shared_path}/cached-copy"
        run "sudo /bin/chown -R www-data:www-data #{deploy_to}"
    end
end



######
before 'deploy:assets:precompile',  'bundle:install'
before 'deploy',         'rvm:install_rvm'
before 'deploy',         'rvm:install_ruby'
before 'deploy:update_code', 'deploy:own_assets'
before 'deploy',         'rvm:create_gemset'
before 'deploy:restart', 'deploy:migrate'
before 'deploy:restart', 'passenger:restart'

after 'deploy:create_symlink', 'deploy:release_assets'
before 'apache:restart', 'deploy:link_config'
after 'deploy:release_assets', 'apache:restart'




