namespace :deploy do
  namespace :gems do
    
    desc "Installs any 'not-yet-installed' gems on the production server or a single gem when the gem= is specified."
    task :install do
      if ENV['gem']
        log "Installing #{ENV['gem']}"
        run "gem install #{ENV['gem']}"
      else
        log "Installing gem dependencies"
        run "cd #{current_path}; rake deployer_gems:install #{env}"
      end
    end
    
  end
end