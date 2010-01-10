namespace :deployer_gems do
  
  task :base do
    begin
      $gems_rake_task = true
      require 'rubygems'
      require 'rubygems/gem_runner'
      Rake::Task[:environment].invoke
    rescue
    end
  end
  
  desc "Installs all required gems."
  task :install => :base do
    current_gems.each { |gem| gem.install }
  end
  
end