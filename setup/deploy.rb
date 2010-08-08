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
# Set options for bundle install
# Will speed up deployment by skipping the bundle install on test and development gems

set :bundle_options, "--without test --without development --production"


##
# Optional
# Specify custom deployment path

# set :deploy_path, "/var/apps/#{appname}"


##
# Optional
# If you want to use a repository from a different location (github.com, trunksapp.com, etc)
# Then you can specify the URL here. When using this, the "cap deploy:repository" tasks won't work.

# set :repository_url, "deployer@example.com:/path/to/repository.git"


##
# Optional
# Use this to define a list of files you want to upload for the deploy:initial task

# set :sync_files,
#   %w(config/mongoid.yml)

##
# Optional
# Use this to skip database deployment tasks (db:create, db:migrate)
# Useful when, for example, not using ActiveRecord, but MongoDB with Mongoid instead

# set :skip_database, true


##
# Optional
# Set options for bundle install
# Can speed up deployment by skipping the bundle install on test and development gems

# set :bundle_options, "--without test --without development"


##
# Optional
# Set bundler path (if in a nonstandard place)

# set :bundle_path, "/usr/local/bin/bundle"


##
# Optional
# Set up additional shared folders. The example below will create:
# SHARED_PATH/public/system
# SHARED_PATH/public/assets
# SHARED_PATH/db

# set :additional_shared_folders,
#   %w(public/system public/assets db)


##
# Optional
# Set up additional shared symlinks
# These are mirrored to the Rails Applications' structure
# public/system         = RAILS_ROOT/public/system          => SHARED_PATH/public/system
# public/assets         = RAILS_ROOT/public/assets          => SHARED_PATH/public/assets
# db/production.sqlite3 = RAILS_ROOT/db/production.sqlite3  => SHARED_PATH/db/production.sqlite3

# set :additional_shared_symlinks,
#   %w(public/system public/assets db/production.sqlite3)


##
# Optional
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

##
# Staging Environment
#
# Deployer lets you define multiple "staging environments"
# Just create the associated setting files at: config/deploy/[stage_name].rb
#
# For example, if you want 2 staging environments (staging and production) you would create 2 files:
# config/deploy/production.rb
# config/deploy/staging.rb
#
# each of these files would have the associated settings for that environment
#
# You can then use this environment by running `cap staging deploy` or `cap production deploy`

##
# Optional
# Setting the default_stage will allow you to define
# which staging environment gets used by default with a standard `cap deploy`

# set :default_stage, "production"

##
# Optional
# By default the files found at config/deploy will be used for the list of stages
# to override this by defining your own, just set them here

# set :stages, %w(test staging production)

##
# Optional
# By default the staging files will be read from ./config/deploy
# to overwrite this path to your own, use this setting

# set :staging_dir, "./my/custom/deploy/folder"
