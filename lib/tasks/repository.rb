namespace :deploy do
  namespace :repository do
    
    task :base do
      if respond_to?(:repository_url)
        log "You cannot interact with your repository through Deployer Tasks as long as you have the \"repository_url\" defined."
        log "Deployer only handles repositories that are located on the same server location as to where the actual Rails Application will be deployed."
        log "If you wish to have this functionality, please comment out the \"repository_url\" inside the config/deploy.rb."
        log "If you wish to use the git repository from a different server, then manually add it to git: git remote add origin repository_url"
        exit
      end
    end

    desc "Creates the remote Git repository."
    task :create => :base do
      log "Creating remote Git repository"
      run "mkdir -p #{repository_path}"
      run "cd #{repository_path} && git --bare init"
      system "git remote rm #{remote}"
      system "git remote add #{remote} #{repository[:repository]}"
      p "#{repository[:repository]} was added to your git repository as #{remote}/master."
    end

    desc "Creates the remote Git repository."
    task :destroy => :base do
      log "destroying remote Git repository"
      run "rm -rf #{repository_path}"
      system "git remote rm #{remote}"
      p "#{repository[:repository]} (#{remote}/master) was removed from your git repository."
    end

    desc "Resets the remote Git repository."
    task :reset => :base do
      log "Resetting remove Git repository"
      system "cap deploy:repository:destroy"
      system "cap deploy:repository:create"
    end
    
    desc "Reinitializes #{remote}/master."
    task :reinitialize => :base do
      system "git remote rm #{remote}"
      system "git remote add #{remote} #{repository[:repository]}"
      p "#{repository[:repository]} (#{remote}/master) was added to your git repository."
    end
    
  end
end