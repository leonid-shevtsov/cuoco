require 'erb'

module Cuoco
  class ConfigGenerator
    def self.chef_config(scope)
      template_path = File.expand_path(File.join(__FILE__, '..', '..', '..', 'templates', 'solo.rb.erb'))
      ERB.new(File.read(template_path)).result(scope)
    end
  end
end