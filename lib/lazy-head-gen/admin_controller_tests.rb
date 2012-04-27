module Padrino
  module Generators

    class AdminControllerTests < Thor::Group
      # register with Padrino
      Padrino::Generators.add_generator(:admin_controller_tests, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      # Defines the banner for this CLI generator
      def self.banner; "padrino-gen admin_controller_tests [name]"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators
      include Padrino::Generators::Actions
      include Padrino::Generators::Runner
      include Padrino::Generators::Components::Actions

      desc "Description:\n\n\tlazy-head-gen admin_controller_tests generates basic tests for an admin controller"

      argument :name, :desc => "The name of your admin controller"

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string

      require_arguments!

      def create_admin_controller_tests
        self.destination_root = options[:root]

        if in_app_root?
          say "Creating basic admin controller tests for '#{name}'", :green

          # Set variables
          @pluralized = name.to_s.tableize
          @singular = name.to_s.underscore.singularize
          @controller = @pluralized.camelize
          @model = @singular.camelize

          # Check that the admin controller exists
          controller_path = destination_root("admin", "controllers", "#{@pluralized}.rb")

          if File.exist?(controller_path)
            template "templates/admin_controller_test.rb.tt", destination_root("test", "admin", "controllers", "#{@pluralized}_controller_test.rb")
          else
            say "The controller '#{controller_path} does not exist, please run 'padrino g admin_page #{@model}' to create the initial admin controller", :red
            return
          end

          say "Admin controller tests generation for '#{name}' completed", :green
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)", :red
        end
      end

    end # AdminControllerTests
  end # Generators
end # Padrino