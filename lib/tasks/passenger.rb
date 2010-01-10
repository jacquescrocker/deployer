namespace :deploy do
  namespace :passenger do
    
    desc "Restarts Passenger"
    task :restart do
      log "Restarting Passenger"
      run "touch #{current_path}/tmp/restart.txt"
    end

  end
end