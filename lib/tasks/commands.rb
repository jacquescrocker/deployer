namespace :deploy do
  namespace :remote_command do
  
    desc "Run a command from the Rails Root on the remote server. Specify command='my_command'."
    task :rails_root do
      log "Executing \"#{ENV['command']}\" from the Rails Root on the server."
      run "cd #{current_path}; #{ENV['command']}"
    end
   
    desc "Run a command on the remote server. Specify command='my_command'."
    task :default do
      log "Executing \"#{ENV['command']}\" on the server."
      run "#{ENV['command']}"
    end
     
  end
end