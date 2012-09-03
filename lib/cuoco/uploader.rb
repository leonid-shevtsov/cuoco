require 'json'
require 'cuoco/config_generator'

module Cuoco
  # This class handles uploading Cuoco and Chef scripts onto the remote machines
  class Uploader
    def initialize(capistrano)
      @cap = capistrano

      @chef_path = File.expand_path(@cap.fetch(:chef_path, 'config/chef'))
      @node_data = @cap.fetch(:chef_data, {})

      @cuoco_remote_path = '/tmp/cuoco'
    end

    def upload
      prepare_directory_structure
      upload_chef_config
      upload_chef_files
      upload_node_json
    end

    def prepare_directory_structure
      prepare_cuoco_directory

      @cap.sudo("mkdir -p /etc/chef", :shell => '/bin/bash')
    end

    def prepare_cuoco_directory
      @cap.sudo("mkdir -p #{@cuoco_remote_path}", :shell => '/bin/bash')
      # Note: $USER gets substituted *before* sudoing; so it contains the real user, not root
      @cap.sudo("chown $USER #{@cuoco_remote_path}", :shell => '/bin/bash')
      @cap.run("rm -rf #{@cuoco_remote_path}/*", :shell => '/bin/bash')
    end

    def upload_chef_config
      @config_contents = Cuoco::ConfigGenerator.chef_config(binding)
      @cap.put(@config_contents, @cuoco_remote_path+'/solo.rb')
      @cap.sudo("mv #{@cuoco_remote_path}/solo.rb /etc/chef/solo.rb", :shell => '/bin/bash')
    end

    def upload_chef_files
      @cap.upload(@chef_path, @cuoco_remote_path+'/chef', :recursive => true)
      @cap.run("#{@cap.sudo} rm -rf /var/chef && #{@cap.sudo} mv #{@cuoco_remote_path}/chef /var/chef && #{@cap.sudo} chown -R root:root /var/chef", :shell => '/bin/bash')
    end

    def upload_node_json
      @cap.put(@node_data.to_json, @cuoco_remote_path+'/node.json')
    end
  end
end