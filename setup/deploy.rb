# Quick Reference
# Configure the essential configurations below and do the following:
# 
#   Create Local and Remote Repository:
#     git init
#     cap deploy:repository:create
# 
#   Initial Deployment:
#     git add .
#     git commit -am "Initial commit for deployment"
#     git push origin master
#     cap deploy:initial
#     
#   Then For Every Update Just Do:
#     git add .
#     git commit -am "some other commit"
#     git push origin master
#     cap deploy
#
#   For Apache2 Users
#     cap deploy:apache:create
#     cap deploy:apache:destroy
#     cap deploy:apache:restart
#     cap deploy:apache:destroy_all
#
#   For NginX Users
#     cap deploy:nginx:create
#     cap deploy:nginx:destroy
#     cap deploy:nginx:restart
#     cap deploy:nginx:destroy_all
#
#   For a Full List of Commands
#     cap -T

set :ip,          "123.45.678.90"
set :domain,      "example.com"
set :subdomain,   false
set :user,        "root"

# Set up additional shared folders
set :additional_shared_folders,
  %w(public/assets db)

# Set up additional shared symlinks
set :additional_shared_symlinks,
  %w(public/assets db/production.sqlite3)

# Add custom tasks to execute after each deployment
# These will run before passenger restarts and before the permissions are set on the application
# so that all changes will be initialized and receive the proper permissions
def after_deploy
  # run_custom_task "my_custom_task"
  # run_custom_task "nested:my_custom_task"
end

# Application Specific Deployment Tasks
namespace :deploy do
  
  # desc "This is my custom task."
  # task :my_custom_task do
  #   run "tree #{shared_path}"
  # end
  # 
  # namespace :nested do
  #   desc "This is my nested custom task."
  #   task :my_custom_task do
  #     puts "tree #{shared_path}"
  #   end
  # end

end