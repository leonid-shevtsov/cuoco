module Cuoco
  class Bootstrapper
    BOOTSTRAP_COMMAND = "\
      if ! command -v chef-solo &>/dev/null;\
      then\
        if command -v curl &>/dev/null;
        then
          curl -L http://opscode.com/chef/install.sh | sudo -p \"sudo password: \" bash;\
        else
          wget -q -O - http://opscode.com/chef/install.sh | sudo -p \"sudo password: \" bash;\
        fi;
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

    def initialize(capistrano)
      @cap = capistrano
    end

    def bootstrap
      @cap.run(BOOTSTRAP_COMMAND, :shell => '/bin/bash')
    end
  end
end