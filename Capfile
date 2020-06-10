# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails/migrations"
require 'capistrano/puma'
install_plugin Capistrano::Puma  # Default puma tasks
install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template
require 'capistrano/figaro_yml'
require 'capistrano/rails/console'
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
