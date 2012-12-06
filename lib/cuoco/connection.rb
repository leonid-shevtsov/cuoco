module Cuoco
  # This module invokes methods on the remote machines based on a Ruby API
  module Connection
    class << self
      # Has to be called before doing anything with capistrano
      def attach_to_capistrano(capistrano)
        @capistrano = capistrano
      end

    private
      # Always uses /bin/bash as the shell to avoid conflict with Capistrano plugins
      # that override the default shell, like rvm-capistrano
      #
      # "sudo" mentioned in the command line will be replaced with
      # a capistrano #{sudo} call, to patch in any options from Capistrano
      # 
      # REMEMBER! All commands are run in *parallel* on all servers
      def run(command)
        command = command.gsub("\bsudo\b", @capistrano.sudo)
        @capistrano.run(command, :shell => '/bin/bash')
      end
    end
  end
end