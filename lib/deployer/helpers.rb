##
# Alias for initializing custom deployment tasks
def run_custom_task(task)
  system "cap deploy:#{task}"
end

##
# Helper Method that assists in loading in tasks from the tasks folder
def load_tasks(tasks)
  load File.join(File.dirname(__FILE__), 'tasks', "#{tasks}.rb")
end

##
# Method that logs a message
def log(message)
  puts "\n\n[Deployer] => #{message}.. \n\n"
end

##
# Returns the RAILS_ENV=production string to reduce overhead
def env
  "RAILS_ENV=production"
end

##
# Returns the path to the 'rake' executable
def rake_path
  return @rake_path if @rake_path
  Net::SSH.start(ip, user) do |ssh|
    @rake_path = ssh.exec!("which rake").chomp || "rake"
  end
  @rake_path
end

##
# Returns the path to Bundler's 'bundle' executable
def bundle_path
  return @bundle_path if @bundle_path
  Net::SSH.start(ip, user) do |ssh|
    @bundle_path = ssh.exec!("which bundle") || "bundle"
  end
  @bundle_path  
end

##
# Returns true or false, depending on whether the bundle is satisfied (dependencies are installed)
def bundle_satisfied?
  return @bundle_satisfied if @bundle_satisfied
  Net::SSH.start(ip, user) do |ssh|
    if ssh.exec!("cd #{current_path}; #{bundle_path} check") =~ /The Gemfile's dependencies are satisfied/
      @bundle_satisfied = true
    else
      @bundle_satisfied = false
    end
  end
  @bundle_satisfied
end