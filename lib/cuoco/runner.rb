module Cuoco
  class Runner
    # $CAPISTRANO:HOSTROLES$ is a magic Capistrano placeholder that gets replaced 
    # with a comma-delimited list of roles *for each specific server individually*.
    # See Capistrano::Command#replace_placeholders
    # The awk command translates "app,web,db" into "role[app],role[web],role[db]" to pass them to Chef
    SERVER_ROLES = %Q{`echo '$CAPISTRANO:HOSTROLES$' | awk '{sub(/^/,"role["); sub(/$/,"]"); gsub(/,/,"],role["); print}'`}

    def initialize(capistrano)
      @cap = capistrano
    end

    def run
      run_list(SERVER_ROLES)
    end

    def run_list(roles_and_recipes)
      if roles_and_recipes.is_a? Array
        roles_and_recipes = roles_and_recipes.join(',')
      end

      @cap.sudo(chef_command(roles_and_recipes), :shell => '/bin/bash')
    end

  private
    def chef_command(roles_and_recipes)
      "chef-solo -j /tmp/cuoco/node.json -o #{roles_and_recipes}"
    end
  end
end