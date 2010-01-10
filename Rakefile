require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "deployer"
    gem.summary = %Q{Deployer is a deployment engine (Ruby Gem) that enhances Capistrano with a set of useful automated deployment tasks. It favors convention over configuration, and it simplifies Rails Application Deployment with Capistrano.}
    gem.description = %Q{Deployer is a deployment engine (Ruby Gem) that enhances Capistrano with a set of useful automated deployment tasks. It favors convention over configuration, and it simplifies Rails Application Deployment with Capistrano.}
    gem.email = "meskyanichi@gmail.com"
    gem.homepage = "http://github.com/meskyanichi/deployer"
    gem.authors = ["Michael van Rooijen"]
    gem.add_dependency "capistrano", ">= 2.5.13"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "deployer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
