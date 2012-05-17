set :application, "MyRunApp"
 
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/app/myrunapp"
 
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true

set :scm, :git
set :repository, "git@github.com:nandotorres/myrunapp.git"
set :branch, "master"
set :deploy_via, :remote_cache
 
set :user, 'nandotorres'
set :ssh_options, { :forward_agent => true }
 
role :app, "50.17.222.29"
role :web, "50.17.222.29"
role :db,  "50.17.222.29", :primary => true

namespace :deploy do
    task :ln_assets do
      run <<-CMD
        rm -rf #{latest_release}/public/assets &&
        mkdir -p #{shared_path}/assets &&
        ln -s #{shared_path}/assets #{latest_release}/public/assets
      CMD
    end

    task :assets do
      update_code
      ln_assets
    
      run_locally "rake assets:precompile"
      run_locally "cd public; tar -zcvf assets.tar.gz assets"
      top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
      run "cd #{shared_path}; tar -zxvf assets.tar.gz"
      run_locally "rm public/assets.tar.gz"
      run_locally "rm -rf public/assets"
    
      create_symlink
      restart
    end
end

#para rodar o bundle antes do assets https://github.com/capistrano/capistrano/issues/81
before "deploy", 'deploy:assets'

desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

#after 'deploy:update_code' do
#  run "cd #{release_path}; RAILS_ENV=production /home/raro/.rvm/wrappers/ruby-1.9.2-p290/rake assets:precompile"
#end