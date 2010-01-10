namespace :deploy do
  namespace :environment do

    desc "Creates the production environment"
    task :create do
      system "cap deploy:setup"
    end

    desc "Destroys the production environment"
    task :destroy do
      run "rm -rf #{deploy_to}"
    end
  
    desc "Resets the production environment"
    task :reset do
      run "rm -rf #{deploy_to}"
      system "cap deploy:setup"
    end

  end
end