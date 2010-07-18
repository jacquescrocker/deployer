namespace :deploy do
  namespace :gems do

    desc "Installs dependencies for application, or a single gem when the gem= is specified."
    task :install do
      if ENV['gem']
        log "Installing #{ENV['gem']}"
        run "gem install #{ENV['gem']}"
      else
        log "Installing gem dependencies"
        if bundle_satisfied? and ENV['force'] != "true"
          puts "The Gemfile's dependencies are satisfied"
        else
          run "cd #{current_path}; #{bundle_path} install #{bundle_options if respond_to?(:bundle_options)}"
        end
      end
    end

  end
end