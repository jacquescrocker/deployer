def create_tmp_file(contents)
  system 'mkdir tmp'
  file = File.new("tmp/#{domain}", "w")
  file << contents
  file.close
end

def run_custom_task(task)
  system "cap deploy:#{task}"
end

def load_tasks(tasks)
  load File.join(File.dirname(__FILE__), '..', 'tasks', "#{tasks}.rb")
end

def log(message)
  puts "\n\n[Deployer] => #{message}.. \n\n"
end

def env
  "RAILS_ENV=production"
end