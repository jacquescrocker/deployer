namespace :deploy do
  namespace :db do

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