require 'cuoco'

::Capistrano::Configuration.instance(:must_exist).load do
  namespace :cuoco do
    desc "Configures remote servers using Chef Solo"
    task :update_configuration do
      bootstrap
      run_roles
    end

    desc "Sets up Chef on remote server"
    task :bootstrap do
      bootstrapper = Cuoco::Bootstrapper.new(self)
      bootstrapper.bootstrap
    end

    desc "Uploads Cuoco and Chef files to remote servers"
    task :upload_files do
      uploader = Cuoco::Uploader.new(self)
      uploader.upload
    end

    desc "Executes Chef Solo with role-based run lists"
    task :run_roles do
      upload_files

      runner = Cuoco::Runner.new(self)
      runner.run
    end

    desc "Executes Chef Solo with a custom run list"
    task :run_list do
      list = fetch(:chef_run_list, [])
      if list.empty?
        abort ":chef_run_list is empty"
      end

      upload_files

      runner = Cuoco::Runner.new(self)
      runner.run_list( list )
    end
  end
end