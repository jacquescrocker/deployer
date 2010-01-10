namespace :deploy do
  namespace :db do
    
    desc "Syncs the database.yml file from the local machine to the remote machine"
    task :sync_yaml do
     log "Syncing database yaml to the production server"
     unless File.exist?("config/database.yml")
       puts "There is no config/database.yml.\n "
       exit
     end
     system "rsync -vr --exclude='.DS_Store' config/database.yml #{user}@#{application}:#{shared_path}/config/"
    end

    desc "Create Production Database"
    task :create do
     log "Creating the Production Database"
     run "cd #{current_path}; rake db:create #{env}"
    end
    
    namespace :migrate do
      
      desc "Migrate Production Database"
      task :default do
       log "Migrating the Production Database"
       run "cd #{current_path}; rake db:migrate #{env}"
      end

      desc "Resets the Production Database"
      task :reset do
       log "Resetting the Production Database"
       run "cd #{current_path}; rake db:migrate:reset #{env}"
      end

    end
      
    desc "Destroys Production Database"
    task :drop do
     log "Destroying the Production Database"
     run "cd #{current_path}; rake db:drop #{env}"
    end

    desc "Moves the SQLite3 Production Database to the shared path"
    task :move_to_shared do
     log "Moving the SQLite3 Production Database to the shared path"
     run "mv #{current_path}/db/production.sqlite3 #{shared_path}/db/production.sqlite3"
     system "cap deploy:setup_symlinks"
    end

    desc "Populates the Production Database"
    task :seed do
     log "Populating the Production Database"
     run "cd #{current_path}; rake db:seed #{env}"
    end
    
  end
end