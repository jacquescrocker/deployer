namespace :deploy do
  namespace :db do
    
    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
     log "Syncing local database.yml (config/database.yml) to the shared folder (#{appname}/shared/config/database.yml)"
     unless File.exist?("config/database.yml")
       puts "There is no config/database.yml.\n "
       exit
     end
     system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{application}:#{shared_path}/config/"
    end

    desc "Create the database"
    task :create do
      log "Creating the database"
      run "cd #{current_path}; #{rake_path} db:create #{env}"
    end
    
    namespace :migrate do
      
      desc "Migrate the database"
      task :default do
       log "Migrating the database"
       run "cd #{current_path}; #{rake_path} db:migrate #{env}"
      end

      desc "Reset the database"
      task :reset do
       log "Resetting the database"
       run "cd #{current_path}; #{rake_path} db:migrate:reset #{env}"
      end

    end
      
    desc "Drop the database"
    task :drop do
     log "Dropping the database"
     run "cd #{current_path}; #{rake_path} db:drop #{env}"
    end

    desc "Populate the database"
    task :seed do
     log "Seeding the database"
     run "cd #{current_path}; #{rake_path} db:seed #{env}"
    end
    
  end
end