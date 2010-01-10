# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'deployer', 'helpers')

# Load Deployment Tasks
load_tasks("global")
load_tasks("passenger")
load_tasks("apache")
load_tasks("nginx")
load_tasks("plugin")
load_tasks("db")
load_tasks("gems")
load_tasks("repository")
load_tasks("environment")
load_tasks("commands")

# This configuration is *conventional*
set   :application,         ip
set   :deploy_to,           "/var/rails/#{domain}"
set   :repository_path,     "/var/git/#{domain}.git"
set   :repository,          "ssh://#{user}@#{application}#{repository_path}"

# The following configuration *optional*
set   :scm,                 "git"
set   :branch,              "master"
set   :use_sudo,            true
role  :web,                 application
role  :app,                 application
role  :db,                  application
default_run_options[:pty] = true