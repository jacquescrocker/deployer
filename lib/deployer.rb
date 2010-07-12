##
# Returns a path that can be loaded by the "load" method inside the Capfile
def deployer
  File.join(File.dirname(__FILE__), 'deployer', 'deploy.rb')
end