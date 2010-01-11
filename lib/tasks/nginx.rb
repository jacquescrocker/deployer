namespace :deploy do
  namespace :nginx do
    
    desc "Adds NginX configuration and enables it."
    task :create do
      log "Adding NginX Virtual Host for #{domain}"
      config = <<-CONFIG
      server {
        listen 80;
        server_name #{unless subdomain then "www.#{domain} #{domain}" else domain end};
        root #{File.join(deploy_to, 'current', 'public')};
        passenger_enabled on;
      }
      CONFIG
      
      create_tmp_file(config)
      run "mkdir -p #{nginx_sites_enabled_path}"
      system "rsync -vr tmp/#{domain} #{user}@#{application}:#{File.join(nginx_sites_enabled_path, domain)}"
      File.delete("tmp/#{domain}")
      system 'cap deploy:nginx:restart'
    end
    
    desc "Restarts NginX."
    task :restart do
      Net::SSH.start(application, user) {|ssh| ssh.exec "#{nginx_initialize_utility_path} stop"}
      Net::SSH.start(application, user) {|ssh| ssh.exec "#{nginx_initialize_utility_path} start"}
    end
    
    desc "Removes NginX configuration and disables it."
    task :destroy do
      log "Removing NginX Virtual Host for #{domain}"
      begin
        run("rm #{File.join(nginx_sites_enabled_path, domain)}")
      ensure
        system 'cap deploy:nginx:restart'
      end
    end
    
    desc "Destroys Git Repository, Rails Environment and Nginx Configuration."
    task :destroy_all do
      system "cap deploy:repository:destroy"
      run "rm -rf #{deploy_to}"
      system "cap deploy:nginx:destroy"
    end

  end
end