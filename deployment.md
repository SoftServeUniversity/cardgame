Deployment instruction
================

Remote Server machine
-------
    I created a separate folder and did the whole vagrant init there.
    I configured the Vagrant file to use a bridged network.
    I signed into my vagrant VM ($ vagrant ssh) and ran ifconfig to get my ip.  

     THIS IP is refered later as 123.123.123.123

Remote Server machine preparation
-------

ssh to root in terminal with your server ip

    ssh root@123.123.123.123

Add ssh fingerprint and enter password provided Change password

    passwd

Create new user

    adduser username_for_deployer

Set new users privileges

    visudo

Find user privileges section

    # User privilege specification
    root  ALL=(ALL:ALL) ALL

Add your new user privileges under root & cntrl+x then y to save

    username_for_deployer ALL=(ALL:ALL) ALL

Configure SSH

    nano /etc/ssh/sshd_config

Find and change port to one that isn't default(22 is default: choose between 1025..65536)

    Port 22 # change this to whatever port you wish to use
    Protocol 2
    PermitRootLogin no

Add to bottom of sshd_config file after changing port (cntrl+x then y to save)

    UseDNS no
    AllowUsers username_for_deployer

Reload ssh

    reload ssh

Don't close root! Open new shell and ssh to vps with new username(remember the port, or you're locked out!)

    ssh -p Configure SSH

    nano /etc/ssh/sshd_config

Find and change port to one that isn't default(22 is default: choose between 1025..65536)

    Port 22 # change this to whatever port you wish to use
    Protocol 2
    PermitRootLogin no

Add to bottom of sshd_config file after changing port (cntrl+x then y to save)

    UseDNS no
    AllowUsers username_for_deployer

Reload ssh

    reload ssh

Don't close root! Open new shell and ssh to vps with new username(remember the port, or you're locked out!)

    ssh -p 1026 username_for_deployer@123.123.123.123

Update packages on virtual server

    sudo apt-get update
    sudo apt-get install curl

Install ruby dependencies

    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
    
Install rbenv

    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc

    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

    git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

    git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs

Install ruby 

    rbenv install 2.1.2
    rbenv rehash
    rbenv global 2.1.2

install rails gem

    gem install rails --no-ri --no-rdoc

Install postgres

    sudo apt-get --purge remove postgresql\*

    sudo locale-gen en_US en_US.UTF-8
    sudo dpkg-reconfigure locales 

    echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
    echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

    export LANGUAGE="en_US.UTF-8"

    sudo apt-get install libpq-dev
    sudo apt-get install postgresql postgresql-contrib

    sudo pg_createcluster 9.3 main --start

    gem install pg -- --with-pg-config=/usr/bin/pg_config

    sudo -u postgres psql
    create user application_name with password 'PASSWORD'; 
    // Change the PASSWORD to your password
    
    alter role application_name superuser createrole createdb replication;

    create database application_name_production owner application_name;

    Ctrl+Z

Install bundler gem

    gem install bundler

Setup Nginx

    sudo apt-get install nginx
    nginx -h
    cat /etc/init.d/nginx
    /etc/init.d/nginx -h
    sudo service nginx start
    cd /etc/nginx

1. Created user for application deploy
2. Rbenv, ruby
3. Rails
4. Postgre and created database for production with name application_name_production ( shall be used in database.yml in production server)

Shake hands with github

  # follow the steps in this guide if receive permission denied(public key)
  # https://help.github.com/articles/error-permission-denied-publickey
  ssh github@github.com

Capistrano 3 configuration (local machine)
-------


1. Nginx configuration / nginx.conf

CREATE config/nginx.conf 

(change projectname and username to match your directory structure!) (also be aware of client_max_body_size setting, please look at nginx documentation for more information!)

conf/nginx.conf

    upstream unicorn {
      server unix:/tmp/unicorn.specplast.sock fail_timeout=0;
    }

    server {
      listen 81 default_server deferred;
      # server_name example.com;

      # TODO - change root folder to you server !!!
      
      root /var/www/specplast_prod/current;

      location ^~ /assets/ {
        gzip_static on;
        expires max;
        add_header Cache-Control public;
      }

      try_files $uri/index.html $uri @unicorn;
      location @unicorn {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://unicorn;
      }

      error_page 500 502 503 504 /500.html;
      client_max_body_size 20M;
      keepalive_timeout 10;
    }

2. Unicorn configuration / unicorn.rb, unicorn_init.sh

[LOCAL MACHINE] local unicorn setup

    Add unicorn to the gemfile
    create config/unicorn.rb & config/unicorn_init.sh file
    chmod +x config/unicorn_init.sh

config/unicorn.rb

    root = "/var/www/specplast_prod/current"

    working_directory root

    pid "#{root}/tmp/pids/unicorn.pid"

    stderr_path "#{root}/log/unicorn.log"
    stdout_path "#{root}/log/unicorn.log"

    # listen on both a Unix domain socket and a TCP port,
    # we use a shorter backlog for quicker failover when busy
    listen "/tmp/unicorn.specplast.sock"

    worker_processes 2
    timeout 30

    # Force the bundler gemfile environment variable to
    # reference the capistrano "current" symlink
    before_exec do |_|
      ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
    end

    config/unicorn_init.sh

      #!/bin/sh
    ### BEGIN INIT INFO
    # Provides:          unicorn
    # Required-Start:    $remote_fs $syslog
    # Required-Stop:     $remote_fs $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Manage unicorn server
    # Description:       Start, stop, restart unicorn server for a specific application.
    ### END INIT INFO
    set -e

    # Feel free to change any of the following variables for your app:
    TIMEOUT=${TIMEOUT-60}
    APP_ROOT=/var/www/specplast_prod/current
    PID=$APP_ROOT/tmp/pids/unicorn.pid
    CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E production"
    AS_USER=specplast
    set -u

    OLD_PIN="$PID.oldbin"

    sig () {
      test -s "$PID" && kill -$1 `cat $PID`
    }

    oldsig () {
      test -s $OLD_PIN && kill -$1 `cat $OLD_PIN`
    }

    run () {
      if [ "$(id -un)" = "$AS_USER" ]; then
        eval $1
      else
        su -c "$1" - $AS_USER
      fi
    }

    case "$1" in
    start)
      sig 0 && echo >&2 "Already running" && exit 0
      run "$CMD"
      ;;
    stop)
      sig QUIT && exit 0
      echo >&2 "Not running"
      ;;
    force-stop)
      sig TERM && exit 0
      echo >&2 "Not running"
      ;;
    restart|reload)
      sig HUP && echo reloaded OK && exit 0
      echo >&2 "Couldn't reload, starting '$CMD' instead"
      run "$CMD"
      ;;
    upgrade)
      if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
      then
        n=$TIMEOUT
        while test -s $OLD_PIN && test $n -ge 0
        do
          printf '.' && sleep 1 && n=$(( $n - 1 ))
        done
        echo

        if test $n -lt 0 && test -s $OLD_PIN
        then
          echo >&2 "$OLD_PIN still exists after $TIMEOUT seconds"
          exit 1
        fi
        exit 0
      fi
      echo >&2 "Couldn't upgrade, starting '$CMD' instead"
      run "$CMD"
      ;;
    reopen-logs)
      sig USR1
      ;;
    *)
      echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
      exit 1
      ;;
    esac

3. Capistrano deploy.rb configuration

Add capistrano and rbenv capistrano to gemfile

    gem 'capistrano'
    gem 'capistrano-rbenv'

Create capfile & config/deploy.rb files

    cap install

config/deploy.rb

  set :stage, :production
  set :application, "specplast"

  set :rbenv_ruby, '2.1.2'

  set :scm, :git
  set :repo_url,  "git@github.com:ichyr/#{fetch(:application)}.git"
  set :branch, 'production'

  set :deploy_to, "/var/www/specplast_prod"

  set :ssh_options, {
    forward_agent: true,
    port: 10375
  }

  set :log_level, :debug

  set :linked_files, %w{config/database.yml}
  set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

  SSHKit.config.command_map[:rake]  = "bundle exec rake" #8
  SSHKit.config.command_map[:rails] = "bundle exec rails"

  set :keep_releases, 10

  namespace :deploy do

    desc "checks whether the currently checkout out revision matches the
    remote one we're trying to deploy from"
      task :check_revision do
        branch = fetch(:branch)
        unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
          puts "WARNING: HEAD is not the same as origin/#{branch}"
          puts "Run `git push` to sync changes or make sure you've"
          puts "checked out the branch: #{branch} as you can only deploy"
          puts "if you've got the target branch checked out"
        exit
      end
    end

    %w[start stop restart].each do |command|
      desc "#{command} Unicorn server."
      task command do
        on roles(:app) do
          execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
        end
      end
    end

    before :deploy, "deploy:check_revision"
    after :deploy, "deploy:restart"
    after :rollback, "deploy:restart"

  end

Capfile

    # Load DSL and set up stages
    require 'capistrano/setup'

    # Include default deployment tasks
    require 'capistrano/deploy'

    # Include tasks from other gems included in your Gemfile
    #
    # For documentation on these, see for example:
    #
    #   https://github.com/capistrano/rvm
    #   https://github.com/capistrano/rbenv
    #   https://github.com/capistrano/chruby
    #   https://github.com/capistrano/bundler
    #   https://github.com/capistrano/rails
    #   https://github.com/capistrano/passenger
    #
    require 'capistrano/rails'
    require 'capistrano/rbenv'
    # require 'capistrano/chruby'
    require 'capistrano/bundler'
    # require 'capistrano/rails/assets'
    # require 'capistrano/rails/migrations'
    # require 'capistrano/passenger'

    # Load custom tasks from `lib/capistrano/tasks' if you have any defined
    Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

Remote configuration 2
--------------

Add ssh key to digitalocean

  cat ~/.ssh/id_rsa.pub | ssh -p 22 username@123.123.123.123 'cat >> ~/.ssh/authorized_keys'

  # Specify your port !!!

  Error bash: /home/specplast/.ssh/authorized_keys: No such file or directory

  ON REMOTE: mkdir ~/.ssh

# Add config/database.yml to .gitignore



Deployment

  gem install capistrano
  gem install capistrano-bundler
  gem install capistrano-rails
  gem install capistrano-rails-console
  gem install capistrano-rbenv

If the deploy_to folder doesn't exist on your target server create it using:

    sudo mkdir -p /var/www/staging.example.com

Then change the folder ownership and permissions as follows:

    sudo chown deployer:deployer_group /var/www/staging.example.com/

Install dependencies

    Install RMAGICK
        sudo apt-get install imagemagick libmagickwand-dev

    Install NodeJs
      
        sudo add-apt-repository ppa:chris-lea/node.js

        sudo apt-get update

        sudo apt-get install nodejs

Waringn ad error related to deploy

    sudo chmod o-w /usr/local
    sudo chmod o+w /etc/nginx/sites-enabled/
    sudo chmod o+w /etc/init.d/

Check for errors in deploy configuration

  cap production deploy:check

Nginx Logs

    cat /var/log/nginx/error.log
    cat /var/log/nginx/access.log

Unicorn logs

    cat /var/www/specplast_prod/current/log/unicorn.log

Rails secrets problem

    app error: Missing `secret_token` and `secret_key_base` for 'production' environment, set these values in `config/secrets.yml` (RuntimeError)

    append before config to config/secrets.yml

    <%
      Rails.application.config.before_configuration do
        env_file = File.join(Rails.root, '.env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end if File.exists?(env_file)
      end
    %>

5. Deploy

add setup tasks

lib/capistrano/tasks/setup.rake

    namespace :setup do

      desc "Upload database.yml file."
      task :upload_yml do
        on roles(:app) do
          # execute "mkdir -p #{shared_path}/config"
          upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
          upload! StringIO.new(File.read(".env.yml")), "/var/www/specplast_prod/current/.env.yml"
        end
      end

      desc "Seed the database."
      task :seed_db do
        on roles(:app) do
          within "#{current_path}" do
            with rails_env: :production do
              execute :rake, "db:seed"
            end
          end
        end
      end

      desc "Symlinks config files for Nginx and Unicorn."
      task :symlink_config do
        on roles(:app) do
          execute "rm -f /etc/nginx/sites-enabled/default"

          execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
          execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
       end
      end

    end

Run deploy scripts

    cap production deploy
    cap production setup:upload_yml