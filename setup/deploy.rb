# Quick Reference
# Configure the essential configurations below and do the following:
#
#   For more information:
#   http://github.com/meskyanichi/deployer 
#
#   Create Local and Remote Repository:
#   This will create a git repository on the deployment server
#   Will not work when using a remote location such as github.com, trunksapp.com
#     git init
#     cap deploy:repository:create
# 
#   Initial Deployment:
#     git add .
#     git commit -m "Initial commit for deployment"
#     git push origin [:branch]
#     cap deploy:initial
#     
#   Then For Every Update Just Do:
#     git add .
#     git commit -am "some other commit"
#     git push origin [:branch]
#     cap deploy
#
#   For a Full List of Commands
#     cap -T


##
# Essential Configuration
# Assumes Application and Git Repository are located on the same server
set :appname,   "example.com"     # the name of your application
set :ip,        "123.45.678.90"   # the ip address of the production server
set :user,      "deployer"        # the user that will deploy to the production server
set :remote,    "origin"          # the remote that should be deployed
set :branch,    "production"      # the branch that should be deployed


##
# Optional
# If you want to use a repository from a different location (github.com, trunksapp.com, etc)
# Then you can specify the URL here. When using this, the "cap deploy:repository" tasks won't work.
set :repository_url, "deployer@example.com:/path/to/repository.git"


##
# Set up additional shared folders
set :additional_shared_folders,
  %w(public/system db)


##
# Set up additional shared symlinks
# These are mirrored to the Rails Applications' structure
# public/system         = RAILS_ROOT/public/system          => SHARED_PATH/public/system
# db/production.sqlite3 = RAILS_ROOT/db/production.sqlite3  => SHARED_PATH/db/production.sqlite3
set :additional_shared_symlinks,
  %w(public/system db/production.sqlite3)


##
# Additional Application Specific Tasks and Callbacks
# In here you can specify which Application Specific tasks you would like to run right before
# Passenger restarts the application. You invoke the by simply calling "run_custom_task"
# For a list of all the available tasks that you could add to this "after_deploy" method, run: cap -T
def after_deploy
  # run_custom_task "my_custom_task"
  # run_custom_task "nested:my_custom_task"
end

##
# Application Specific Deployment Tasks
# In here you may specify any application specific and/or other tasks that are not handled by Deployer
# These can be invoked by creating a "run_custom_task" method in the "after_deploy" method above
namespace :deploy do  
  desc "Invoke this task manually by running: 'cap deploy:my_custom_task'"
  task :my_custom_task do
    # run "some command"
  end
  
  namespace :nested do
    desc "Invoke this task manually by running: 'cap deploy:nested:my_custom_task'"
    task :my_custom_task do
      # system "some command"
    end
  end
end