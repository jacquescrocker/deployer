namespace :deploy do
  namespace :remote_command do
  
    desc "Run a command from the Rails Root on the remote server. Specify command='my_command'."
    task :rails_root do
      log "Executing \"#{ENV['command']}\" from the Application's root path."
      run "cd #{current_path}; #{ENV['command']}"
    end
   
    desc "Run a command on the remote server. Specify command='my_command'."
    task :default do
      log "Executing \"#{ENV['command']}\"."
      run "#{ENV['command']}"
    end
     
  end
end