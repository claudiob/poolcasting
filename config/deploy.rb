set :application, "pwr"
set :deploy_to, "~/Sites/#{application}"

role :app, "claudiob.iiia.csic.es"
role :web, "claudiob.iiia.csic.es"
role :db,  "claudiob.iiia.csic.es", :primary => true

default_run_options[:pty] = true
set :ssh_options, {:forward_agent => true}

set :scm,               :git
set :scm_command,       "/usr/local/bin/git"
set :local_scm_command, "/usr/local/bin/git"
set :repository,        "git@github.com:claudiob/poolcasting.git"
set :user,              "claudiob"
set :runner,            "claudiob"
set :branch,            "master"
set :deploy_via,        :remote_cache
set :git_shallow_clone, 1

set :mongrel_conf,      "#{deploy_to}/current/config/mongrel_cluster.yml"

after 'deploy:update_code', 'symlink_configs'
task :symlink_configs, :roles=>:app do
  run <<-CMD
    cd #{release_path} &&
    ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml
    ln -nfs #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml
  CMD
end

after 'symlink_configs', 'migrate'
task :migrate, :roles=>:db, :only=>{:primary=>true} do
  rake           = fetch :rake,           'rake'
  rails_env      = fetch :rails_env,      'production'
  migrate_env    = fetch :migrate_env,    ''
  migrate_target = fetch :migrate_target, :latest
 
  directory = case migrate_target.to_sym
    when :current then current_path
    when :latest  then current_release
    else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
  end
 
  run "cd #{directory}; #{rake} RAILS_ENV=#{rails_env} #{migrate_env} #{migrate_env} db:migrate"
end

namespace :deploy do
  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method 
      end
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end

end
