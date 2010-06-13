# Deployer

Deployer is gem that enhances Capistrano to simplify the deployment of Ruby on Rails applications.

It assumes you are using Passenger to serve your Ruby on Rails applications, and Bundler to manage gem dependencies.

It works with **Ruby on Rails 3** and **Ruby on Rails 2** applications as long as you are using **Bundler**.

*If you are currently using the old config.gem method in a Ruby on Rails 2 application, you can easily change this to make it use Bundler instead. [Check out my gist on how to achieve Rails 2 Bundler compatibility.](http://gist.github.com/400609)*


## Getting Started

install the gem

    gem install deployer

create a new Rails app

    rails new my_application

move into the Rails app and execute the "capify" and "enhancify" commands

    cd my_application
    capify .
    enhancify .

enhancify is a command, provided by deployer that will inject some code into the Capfile and replace the config/deploy.rb with the one used for *Deployer*. If the deploy.rb file already exists, it will simply rename it to "deploy.old.1.rb", and if that also exists it will rename it to deploy.old.2.rb, etc. etc. So you will never accidentally overwrite your initial deploy.rb file.

This is what the deploy.rb looks like: "config/deploy.rb":http://github.com/meskyanichi/deployer/blob/master/setup/deploy.rb

*Next, open the config/deploy.rb file and edit the following variables.*

    set :appname,   "example.com"     # the name of your application
    set :ip,        "123.45.678.90"   # the ip address of the production server
    set :user,      "deployer"        # the user that will deploy to the production server
    set :remote,    "origin"          # the remote that should be deployed
    set :branch,    "production"      # the branch that should be deployed


And *that's it!* You are now ready to do the following through *Deployer*:

- Create a remote git repository (only works if on production server)
- Push your initial commit to the remote repository
- Create the production environment to where you will deploy your application to
- And, of course, deploy and run your Rails application!

Here is are the quick-reference comments of the config/deploy.rb file

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


There are more tasks, but these will be your main commands. It's pretty straightforward.

To list all commands:

    cap -T


### Automated Tasks

*Deployer* will invoke various built-in tasks to try and deploy your application successfully.

On the initial setup *cap deploy:initial* (this procedure only has to be performed once)

- It will setup the production environment: releases and shared folder
- It will populate the shared folder with the folders you specified in the deploy.rb file
- It will sync your applications *database.yml* file to the shared/config folder

And the deployment procedure that follows (*cap deploy*), does the following:

- It will create a new folder in the releases folder and deploy your application to it
- It will ensure that the shared folder has all the folders you specified in the *deploy.rb*
- It will setup built-in symlink setups for your database.yml, production log
- It will also setup any additional symlinks you may have specified inside the *deploy.rb* from the release folder to the shared folder
- It will ensure all gems that are specified inside the Gemfile are installed.
- It will ensure the database is present and migrated to the latest version
- It will then perform any *custom* tasks you might have specified inside the *deploy.rb* file within the *after_deploy* method definition
- It will then restart passenger (your application)

So now the application has been deployed. For pushing new versions to the server you do the following:

    git add .
    git commit -m "new version commit"
    git push origin production # or whatever branch you specified in deploy.rb
    cap deploy

## Additional Configuration

*Shared Folders and Symlinks*

I wanted to keep this as simple as possible as well. By default, *Deployer* will create folders for storing the production.log in and other necessary stuff. It will properly symlink it from the shared folder to the Rails application. However! You will most likely have some other things you must keep in a shared folder, such as assets or other files. This can be done easily with *Deployer*.

Again, inside of config/deploy.rb

    set :additional_shared_folders,
      %w(public/assets db)

In this example two paths will be created.

- /var/rails/:appname/shared/public/assets
- /var/rails/:appname/shared/db

*Deployer* will ensure these are available after every deployment. And will append any folders if you change the values here and re-deploy.

Now, what use are these folders if you do not have the ability to add symlinks from these folders to the application.

    set :additional_shared_symlinks,
      %w(public/assets db/production.sqlite3)
  
In this example two symlinks will be created from the shared_path to the current Rails application release.
As you can see the first symlink is a "path" symlink, which does not point to a direct file, but rather a folder.

The second symlink will be a link from the shared/db/production.sqlite3 to the current rails applications' db/production.sqlite3 file.

*NOTE*

One important thing to note here is that notice how the symlinks are mirrored to the Rails applications folder structure. This will always be the case. If you have some crazy architecture inside your Rails application: *rails_root/my/awesome/folder/structure/is/very/long* then you MUST create the following folder structure for the shared path: *shared/my/awesome/folder/structure/is/very/long*. This is a convention and it saves a lot of overhead in your configuration file by just defining a path once and using that same path for both the current and shared path.

*Additional (Optional) (Server) Configuration*

Here you can specify that you want to pull/push from/to a git repository that's located on a DIFFERENT server. Leave this commented out or remove it if your git repository resides on the same server as your Rails application. If you choose to store your git repository on a separate server by uncommenting the following line, then you lose the ability to create/reset/destroy/reinitialize it through *Deployer*. This is no big deal though. All you have to do is create the git repository manually on that specific server and then issue the *git remote add origin repository_url* and it will work fine with the rest of *Deployer*.

    set :repository_url, "deployer@example.com:/path/to/repository.git"

And then here is the last bit of server configuration you can specify.

### Adding Application Specific Deployment Tasks

Inside the *namespace :deploy do* block you can define your own deployment tasks that are specific to your application.

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

Again, very straightforward. Just define your tasks as you normally would with Capistrano.
Then, to invoke them during each deployment you must add them inside the *after_deploy*, method like so:

    def after_deploy
      run_custom_task "my_custom_task"
      run_custom_task "nested:my_custom_task"
    end

This method will be invoked right before *Deployer* sets permissions on, and restarts the your Rails application. 


### Built-in Additional Tasks

*Deployer* has some built-in tasks that are often used by developers.

*Whenever*, To update the crontab on deployment:

    def after_deploy
      run_custom_task "whenever:update_crontab"
    end

*Delayed Job*, To start/stop daemons

    def after_deploy
      run_custom_task "delayed_job:start"
      run_custom_task "delayed_job:start n=3" # "n" specifies the amount of daemons that should run
      run_custom_task "delayed_job:stop"
    end

## Assumptions / Conventions

- Assumes you are using Phusion Passenger
- Assumes Git Repository will be located on the same server as where the actual application will be deployed. Unless specified otherwise in the deploy.rb file.
- The config/database.yml will be transferred to the shared/config/database.yml and symlinked to on the initial deployment. You can re-sync it later with *cap deploy:db:sync_yaml*.
- Assumes you are using Bundler, it no longer supports config/environment.rb's **gem.config** (You can also use Bundler with Rails 2 apps)

## Suggestions, Requests, Idea's?

Tell, Ask, Fork and Help!

## Copyright

Copyright (c) 2010 Michael van Rooijen. See LICENSE for details.
