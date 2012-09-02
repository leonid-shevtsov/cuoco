module Cuoco
  class Bootstrapper
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

    DEFAULT_INSTALL_COMMAND = "
      if command -v curl &>/dev/null;
      then
        curl -L http://opscode.com/chef/install.sh | sudo -p \"sudo password: \" bash;\
      else
        wget -q -O - http://opscode.com/chef/install.sh | sudo -p \"sudo password: \" bash;\
      fi\
    "

    def initialize(capistrano)
      @cap = capistrano

      @install_command = @cap.fetch(:chef_install_command, DEFAULT_INSTALL_COMMAND)
    end

    def bootstrap
      @cap.run(BOOTSTRAP_COMMAND.gsub('INSTALL_COMMAND', @install_command), :shell => '/bin/bash')
    end
  end
end