##
# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'deployer', 'helpers')

##
# This Configuration Is *Conventional*
set   :application,         ip
set   :deploy_to,           "/var/apps/#{appname}"    unless respond_to?(:deploy_to)
set   :repository_path,     "/var/git/#{appname}.git" unless respond_to?(:repository_path)
set   :repository,          "#{user}@#{application}:#{repository_path}"   
set   :repository,          repository_url if respond_to?(:repository_url)

set   :scm,                 'git'
set   :use_sudo,            false
role  :web,                 application
role  :app,                 application
role  :db,                  application
default_run_options[:pty] = true

##
# Default Configuration
set :remote, 'origin' unless respond_to?(:remote)
set :branch, 'master' unless respond_to?(:branch)

##
# Load Deployment Tasks
load_tasks('global')
load_tasks('passenger')
load_tasks('plugin')
load_tasks('db')
load_tasks('gems')
load_tasks('repository')
load_tasks('environment')
load_tasks('commands')