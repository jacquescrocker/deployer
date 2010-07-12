namespace :deploy do
  namespace :whenever do
    
    desc "Update the crontab file for the Whenever gem."
    task :update_crontab, :roles => :db do
      log "Updating the crontab"
      run "cd #{release_path} && whenever --update-crontab #{appname}"
    end    
  end

  namespace :delayed_job do
    desc "Starts the Delayed Job daemon(s)."
    task :start do
      log "Starting #{(ENV['n'] + ' ') if ENV['n']}Delayed Job daemon(s)"
      run "#{env} #{current_path}/script/delayed_job #{"-n #{ENV['n']} " if ENV['n']}start"
    end
    
    desc "Stops the Delayed Job daemon(s)."
    task :stop do
      log "Stopping Delayed Job daemon(s)"
      run "#{env} #{current_path}/script/delayed_job stop"
    end
  end
end