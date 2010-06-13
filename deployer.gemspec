Gem::Specification.new do |gem|
  gem.name    = 'deployer'
  gem.version = '0.1.3'
  gem.date    = Time.now.strftime("%Y-%m-%d")

  gem.summary     = "Deployer is gem that enhances Capistrano to simplify the deployment of Ruby on Rails applications."
  gem.description = "Deployer is gem that enhances Capistrano to simplify the deployment of Ruby on Rails applications."

  gem.authors  = ['Michael van Rooijen']
  gem.email    = 'meskyanichi@gmail.com'
  gem.homepage = 'http://github.com/meskyanichi/deployer'

  gem.files         = Dir['{bin,lib,setup}/**/*', 'README.md', 'LICENSE']
  gem.executables   = ['enhancify']
  
  gem.add_dependency('capistrano', ['>= 2.5.13'])
  gem.add_dependency('OptionParser', ['>= 0.5.1'])
end