# Creates a tmp directory and writes Apache and NginX configuration files to it
def create_tmp_file(contents)
  system 'mkdir tmp'
  file = File.new("tmp/#{domain}", "w")
  file << contents
  file.close
end

# Alias for initializing custom deployment tasks
def run_custom_task(task)
  system "cap deploy:#{task}"
end

# A Helper Method that assists in loading in tasks from the tasks folder
def load_tasks(tasks)
  load File.join(File.dirname(__FILE__), '..', 'tasks', "#{tasks}.rb")
end

# A Method that logs a message
def log(message)
  puts "\n\n[Deployer] => #{message}.. \n\n"
end

# Returns the RAILS_ENV=production string to reduce overhead
def env
  "RAILS_ENV=production"
end