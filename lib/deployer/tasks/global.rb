namespace :deploy do
  
  desc "Initializes a bunch of tasks in order after the last deployment process."
  task :restart do
    system "cap deploy:setup_shared_path"
    system "cap deploy:setup_symlinks"
    system "cap deploy:gems:install"
    unless exists?(:skip_database) and skip_database
      system "cap deploy:db:create"
      system "cap deploy:db:migrate"
    end
    after_deploy if respond_to?(:after_deploy)
    system "cap deploy:passenger:restart"
  end

  desc "Executes the initial procedures for deploying a Ruby on Rails application."
  task :initial do
    system "cap deploy:setup"
    system "cap deploy:setup_shared_path"
    system "cap deploy:sync:files"
  end
  
  desc "Sets up the shared path"
  task :setup_shared_path do
    log "Setting up the shared folders"
    shared_folders = %w(config lib/tasks)
    shared_folders += additional_shared_folders if exists?(:additional_shared_folders)
    shared_folders.each do |folder|
      run "mkdir -p #{shared_path}/#{folder}"
    end
  end
  
  desc "Creates symbolic links from the application to the shared folders"
  task :setup_symlinks do
    log "Creating symbolic links from the application to the shared folders"
    shared_symlinks = %w()
    unless exists?(:skip_database) and skip_database
      shared_symlinks << "config/database.yml"
    end
    shared_symlinks += additional_shared_symlinks if exists?(:additional_shared_symlinks)
    shared_symlinks.each do |symlink|
      run "ln -nfs #{File.join(shared_path, symlink)} #{File.join(current_path, symlink)}"
    end
  end

end