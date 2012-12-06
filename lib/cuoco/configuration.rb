module Cuoco
  # Since Capistrano configuration is essentially singleton, I see no reason
  # not to make this configuration singleton, too
  #
  # All configuration variables used in Cuoco must be declared here
  module Configuration
    class << self

      # The *local* relative or absolute path to the Chef directory
      # The default is config/chef
      attr_reader :chef_path
      DEFAULT_CHEF_PATH = 'config/chef'

      # Data attributes that will be passed to Chef.
      # Must be a hash; the hash will be passed as json, so no blocks or complex objects here
      # The default is an empty hash
      attr_reader :chef_data

      # Command that will install Chef if it's not present on the target system.
      # The default command is Omnibus and works fine in most cases.
      # See Cuoco::Bootstrapper::DEFAULT_INSTALL_COMMAND
      #
      # If the command needs sudo (and it likely does), then use it
      attr_reader :chef_install_command

      # The *remote* absolute path to the directory that Cuoco will use to store its files
      # The default is /var/lib/cuoco and should be OK for most people
      attr_reader :cuoco_path
      DEFAULT_CUOCO_PATH = '/var/lib/cuoco'

      def read_configuration_from_capistrano(capistrano)
        @capistrano = capistrano

        @chef_install_command = @capistrano.fetch(:chef_install_command)

        @chef_path = File.expand_path(@cap.fetch(:chef_path, DEFAULT_CHEF_PATH))
        validate_chef_path!

        @chef_data = @capistrano.fetch(:chef_data, {})
      end

    private
      def validate_chef_path!
        unless File.directory?(@chef_path)
          raise "Directory #{@chef_path} must exist"
        end
      end
    end
  end
end