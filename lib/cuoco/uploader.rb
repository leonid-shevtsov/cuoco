require 'json'
require 'cuoco/config_generator'

module Cuoco
  # This module handles uploading Cuoco and Chef scripts onto the remote machines
  module Uploader
    class << self
      def upload
        build_tarball
        prepare_directory_structure
        upload_tarball
        upload_secret_key
      end

      def build_tarball
        generate_chef_config
        generate_node_json
      end

      def prepare_directory_structure
        Cuoco::Connection.run("sudo mkdir -p #{Cuoco::Configuration.cuoco_path}")
      end

      def upload_chef_config
        @config_contents = Cuoco::ConfigGenerator.chef_config(binding)
        @cap.put(@config_contents, @cuoco_remote_path+'/solo.rb')
        @cap.sudo("mv #{@cuoco_remote_path}/solo.rb /etc/chef/solo.rb", :shell => '/bin/bash')
      end

      def upload_chef_files
        @cap.upload(@chef_path, @cuoco_remote_path+'/chef', :recursive => true)
        inject_cuoco_cookbook
        @cap.run("#{@cap.sudo} rm -rf /var/chef && #{@cap.sudo} mv #{@cuoco_remote_path}/chef /var/chef && #{@cap.sudo} chown -R root:root /var/chef", :shell => '/bin/bash')
      end

      def inject_cuoco_cookbook
        cuoco_cookbook_path = File.expand_path(File.join(__FILE__, '..', '..', '..', 'chef', 'cookbooks', 'cuoco'))
        @cap.upload(cuoco_cookbook_path, @cuoco_remote_path+'/chef/cookbooks/cuoco', :recursive => true)
      end

      def upload_node_json
        @cap.put(@node_data.to_json, @cuoco_remote_path+'/node.json')
      end
    end
  end
end