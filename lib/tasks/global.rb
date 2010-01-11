namespace :deploy do
  
  desc "Initializes a bunch of tasks in order after the last deployment process."
  task :restart do
    system "cap deploy:setup_shared_path"
    system "cap deploy:setup_symlinks"
    system "cap deploy:gems:install"
    system "cap deploy:db:create"
    system "cap deploy:db:migrate"
    after_deploy if respond_to?(:after_deploy)    
    system "cap deploy:set_permissions"
    system "cap deploy:passenger:restart"
  end

  desc "Executes the initial procedures for deploying a Ruby on Rails Application."
  task :initial do
    system "cap deploy:setup"
    system "cap deploy:setup_shared_path"
    system "cap deploy:db:sync_yaml"
    system "cap deploy:sync_tasks"
    system "cap deploy"
  end
  
  desc "Sets permissions for Rails Application"
  task :set_permissions do
    log "Setting Permissions"
    run "chown -R www-data:www-data #{deploy_to}"
  end
  
  desc "Creates symbolic links from shared folder"
  task :setup_symlinks do
    log "Setting up Symbolic Links"
    run "mkdir -p #{File.join(current_path, 'lib', 'tasks')}"
    shared_symlinks = %w(config/database.yml lib/tasks/deployer.rake)
    shared_symlinks += additional_shared_symlinks if respond_to?(:additional_shared_symlinks)
    shared_symlinks.each do |symlink|
      run "ln -nfs #{File.join(shared_path, symlink)} #{File.join(current_path, symlink)}"
    end
  end
  
  desc "Sets up the shared path"
  task :setup_shared_path do
    log "Setting up the shared path"
    shared_folders = %w(config lib/tasks)
    shared_folders += additional_shared_folders if respond_to?(:additional_shared_folders)
    shared_folders.each do |folder|
      run "mkdir -p #{shared_path}/#{folder}"
    end
  end

  desc "Syncs the rake tasks for installing gems."
  task :sync_tasks do
    log "Adding Deployer Rake tasks to shared path."
    system "rsync -vr --exclude='.DS_Store' #{File.join(File.dirname(__FILE__), '..', 'deployer', 'tasks', 'deployer.rake')} #{user}@#{application}:#{File.join(shared_path, 'lib', 'tasks')}"
  end

end