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
      run "mkdir -p /opt/nginx/conf/sites-enabled"
      system "rsync -vr tmp/#{domain} #{user}@#{application}:/opt/nginx/conf/sites-enabled/#{domain}"
      File.delete("tmp/#{domain}")
      system 'cap deploy:nginx:restart'
    end
    
    desc "Restarts NginX."
    task :restart do
      Net::SSH.start(application, user) {|ssh| ssh.exec "/etc/init.d/nginx stop"}
      Net::SSH.start(application, user) {|ssh| ssh.exec "/etc/init.d/nginx start"}
    end
    
    desc "Removes NginX configuration and disables it."
    task :destroy do
      log "Removing NginX Virtual Host for #{domain}"
      begin
        run("rm /opt/nginx/conf/sites-enabled/#{domain}")
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