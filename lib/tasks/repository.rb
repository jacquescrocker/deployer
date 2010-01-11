namespace :deploy do
  namespace :repository do

    desc "Creates the remote Git repository."
    task :create do
      log "Creating remote Git repository"
      run "mkdir -p #{repository_path}"
      run "cd #{repository_path} && git --bare init"
      system "git remote rm #{remote}"
      system "git remote add #{remote} #{repository[:repository]}"
      p "#{repository[:repository]} was added to your git repository as #{remote}/master."
    end

    desc "Creates the remote Git repository."
    task :destroy do
      log "destroying remote Git repository"
      run "rm -rf #{repository_path}"
      system "git remote rm #{remote}"
      p "#{repository[:repository]} (#{remote}/master) was removed from your git repository."
    end

    desc "Resets the remote Git repository."
    task :reset do
      log "Resetting remove Git repository"
      system "cap deploy:repository:destroy"
      system "cap deploy:repository:create"
    end
    
    desc "Reinitializes #{remote}/master."
    task :reinitialize do
      system "git remote rm #{remote}"
      system "git remote add #{remote} #{repository[:repository]}"
      p "#{repository[:repository]} (#{remote}/master) was added to your git repository."
    end
    
  end
end