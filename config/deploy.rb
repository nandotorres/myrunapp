set :default_environment, { 
  'PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global/bin:/home/ubuntu/.rvm/rubies/ruby-1.9.3-p194/bin:/home/ubuntu/.rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/home/ubuntu/.rvm/bin",
  'RUBY_VERSION' => '1.9.3p194',
  'GEM_HOME' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194",
  'GEM_PATH' => "/home/ubuntu/.rvm/gems/ruby-1.9.3-p194:/home/ubuntu/.rvm/gems/ruby-1.9.3-p194@global",
  'LANG' => 'en_US.UTF-8'
}
set :stages, %w(production)
set :default_stage, "production"

require 'capistrano/ext/multistage'
        require './config/boot'
        require 'airbrake/capistrano'
