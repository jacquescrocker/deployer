##
# Load Deployer Helpers
require File.join(File.dirname(__FILE__), 'helpers')

# check stages
set :stage_dir, File.join(".", "config", "deploy") unless exists?(:stage_dir)

# find the list of stages
set :stages, Dir[File.join(stage_dir, "*.rb")].map { |f| File.basename(f, ".rb") } unless exists?(:stages)

# load default stage
if exists?(:default_stage)
  stage_path = File.join(stage_dir, "#{default_stage}.rb")
  load stage_path if File.exists?(stage_path)
end

# set default (so we dont blow up on --tasks / -T)
ip = "[NOT SET]" unless exists?(:ip)
appname = "[NOT SET]" unless exists?(:appname)
user = "[NOT SET]" unless exists?(:user)

##
# This Configuration Is *Conventional*
set   :application,         ip
set   :deploy_to,           exists?(:deploy_path) ? deploy_path : "/var/apps/#{appname}"
set   :repository_path,     "/var/git/#{appname}.git" unless exists?(:repository_path)
set   :repository,          "#{user}@#{application}:#{repository_path}"
set   :repository,          repository_url if exists?(:repository_url)

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
load_tasks('sync')
load_tasks('passenger')
load_tasks('plugin')
load_tasks('db')
load_tasks('gems')
load_tasks('repository')
load_tasks('environment')
load_tasks('commands')
load_tasks('stages')
