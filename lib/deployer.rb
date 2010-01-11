# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'deployer', 'helpers')

# This configuration is *conventional*
set   :application,         ip
set   :deploy_to,           "/var/rails/#{domain}"
set   :repository_path,     "/var/git/#{domain}.git"
set   :repository,          "#{user}@#{application}:#{repository_path}"
set   :repository,          repository_url if respond_to?(:repository_url)

set   :scm,                 "git"
set   :use_sudo,            true
role  :web,                 application
role  :app,                 application
role  :db,                  application
default_run_options[:pty] = true

# Default Configuration
set :remote,                          "origin"                          unless respond_to?(:remote)
set :branch,                          "master"                          unless respond_to?(:branch)
set :apache_initialize_utility_path,  "/etc/init.d/apache2"             unless respond_to?(:apache_initialize_utility_path)
set :apache_sites_available_path,     "/etc/apache2/sites-available"    unless respond_to?(:apache_sites_available_path)
set :nginx_initialize_utility_path,   "/etc/init.d/nginx"               unless respond_to?(:nginx_initialize_utility_path)
set :nginx_sites_enabled_path,        "/opt/nginx/conf/sites-enabled"   unless respond_to?(:nginx_sites_enabled_path)

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