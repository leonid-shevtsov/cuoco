module Cuoco
  module Bootstrapper
    class << self 
      # This is the wrapper around the install command, that checks if
      # Chef is installed already to avoid installing it on every run.
      #
      # The check and the installation have to be one command (or script),
      # because they are running through Capistrano, thus the 'if' statement
      # cannot be on the local side
      BOOTSTRAP_COMMAND = "\
        if ! command -v chef-solo &>/dev/null;\
        then\
          INSTALL_COMMAND;
          if ! command -v chef-solo &>/dev/null;\
          then\
            false;\
          else\
            true;\
          fi;\
        else\
          true;\
        fi\
      ".gsub(/ +/,' ')

      # This command uses Omnibus, the official Chef installer
      # wiki.opscode.com/display/chef/Installing+Omnibus+Chef+Client+on+Linux+and+Mac
      DEFAULT_INSTALL_COMMAND = "
        if command -v curl &>/dev/null;\
        then\
          curl -L http://opscode.com/chef/install.sh | sudo /bin/bash;\
        else\
          wget -q -O - http://opscode.com/chef/install.sh | sudo /bin/bash;\
        fi\
      "

      def bootstrap
        bootstrap_command = BOOTSTRAP_COMMAND.gsub('INSTALL_COMMAND', install_command)
        Cuoco::Connection.run(bootstrap_command)
      end

      def install_command
        Cuoco::Configuration.chef_install_command || DEFAULT_INSTALL_COMMAND
      end
    end
  end
end