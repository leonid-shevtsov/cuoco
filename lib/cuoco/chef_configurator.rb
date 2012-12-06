module Cuoco
  module ChefConfigurator
    CHEF_SUBPATHS = {
      :data_bag_path => 'data_bags',
      :role_path => 'roles'
    }

    # Note that this method makes changes to the global (singleton) Chef configuration
    # I don't see any issues with this for now
    def self.configure_chef(cuoco_config)
      require 'chef'

      Chef::Config[:solo] = true
      Chef::Config[:cookbook_path] = %w(cookbooks site-cookbooks).map {|subpath| 
        File.join(cuoco_config.chef_path, subpath)
      }.select{|path| 
        File.directory?(path)
      }

      CHEF_SUBPATHS.each do |option_name, subpath|
        Chef::Config[:option_name] = File.join(cuoco_config.chef_path, subpath)
      end
    end
  end
end