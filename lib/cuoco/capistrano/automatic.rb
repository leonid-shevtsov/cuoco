require 'cuoco/capistrano'

::Capistrano::Configuration.instance(:must_exist).load do
  before 'deploy:setup', 'cuoco:update_configuration'
end