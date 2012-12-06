module Cuoco
  # This module prepares the command and runs Chef on the remote instances
  module ChefRunner
    class << self
      # $CAPISTRANO:HOSTROLES$ is a magic Capistrano placeholder that gets replaced 
      # with a comma-delimited list of roles *for each specific server individually*.
      # See Capistrano::Command#replace_placeholders
      # The awk command translates "app,web,db" into "role[app],role[web],role[db]" to pass them to Chef
      SERVER_ROLES = %Q{`echo '$CAPISTRANO:HOSTROLES$' | awk '{sub(/^/,"role["); sub(/$/,"]"); gsub(/,/,"],role["); print}'`}

      def run_default_roles
        run_list(SERVER_ROLES+',recipe[cuoco::save_node]')
      end

      def run_list(roles_and_recipes)
        if roles_and_recipes.is_a? Array
          roles_and_recipes = roles_and_recipes.join(',')
        end

        Capistrano::Connection.run(chef_command(roles_and_recipes))
      end

    private
      def chef_command(roles_and_recipes)
        "sudo chef-solo -j /tmp/cuoco/node.json -o #{roles_and_recipes}"
      end
    end
  end
end