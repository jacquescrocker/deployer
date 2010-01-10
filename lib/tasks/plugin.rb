namespace :deploy do
  namespace :whenever do
    
    desc "Update the crontab file for the Whenever Gem."
    task :update_crontab, :roles => :db do
      log "Updating the Crontab"
      run "cd #{release_path} && whenever --update-crontab #{domain}"
    end    
  end

  namespace :delayed_job do
    desc "Starts the Delayed Job Daemon(s)."
    task :start do
      log "Starting #{(ENV['n'] + ' ') if ENV['n']}Delayed Job Daemon(s)"
      run "#{env} #{current_path}/script/delayed_job #{"-n #{ENV['n']} " if ENV['n']}start"
    end
    
    desc "Stops the Delayed Job Daemon(s)."
    task :stop do
      log "Stopping Delayed Job Daemon(s)"
      run "#{env} #{current_path}/script/delayed_job stop"
    end
  end
end