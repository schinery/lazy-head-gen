module Padrino
  module Generators

    class Scaffold < Thor::Group
      # register with Padrino
      Padrino::Generators.add_generator(:scaffold, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      # Defines the banner for this CLI generator
      def self.banner; "padrino g scaffold [name]"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators
      include Padrino::Generators::Actions
      include Padrino::Generators::Runner
      include Padrino::Generators::Components::Actions

      desc "Description:\n\n\tpadrino g scaffold - Generates a fully tested Padrino resource scaffold"

      argument :name, :desc => "The name of your scaffold resource"

      argument :properties, :desc => "The properties of the scaffold's model", :type => :array, :default => []

      class_option :root, :aliases => '-r', :default => ".", :type => :string,
        :desc => "The root destination"

      class_option :app_path, :aliases => '-a', :default => "/app", :type => :string,
        :desc => "The application destination path"

      class_option :model_path, :aliases => '-m', :default => ".", :type => :string,
        :desc => "The model destination path"

      class_option :create_full_actions, :aliases => '-c', :default => false, :type => :boolean,
        :desc => "Specify whether to generate basic (index and show) or full (index, show, new, create, edit, update and delete) actions"

      class_option :skip_migration, :aliases => "-s", :default => false, :type => :boolean,
        :desc => "Specify whether to skip generating a migration"

      # Show help if no argv given
      require_arguments!

      def create_scaffold
        self.destination_root = options[:root]

        if in_app_root?
          app = options[:app_path]
          check_app_existence(app)
          @app_name = fetch_app_name(app)

          say "Generating a Padrino scaffold for '#{name}' in app '#{@app_name}'", :green

          # Set variables
          @pluralized = name.to_s.underscore.pluralize
          @singular = name.to_s.underscore.singularize
          @controller = @pluralized.camelize
          @model = @singular.camelize
          @properties = properties
          @create_full = options[:create_full_actions]

          # Create model
          if invalids = invalid_fields(@properties)
            say "Invalid property name:", :red
            say " #{invalids.join(", ")}"
            raise SystemExit
          end

          unless include_component_module_for(:orm)
            say "You need an ORM adapter to create this scaffold's model", :red
            return
          end

          # TODO: if model path does not equal "." should we check app exists?
          # model_path = options[:model_path]
          model_path = "."

          template "templates/scaffold/model.rb.tt", destination_root(model_path, "models", "#{@singular}.rb")
          template "templates/scaffold/model_test.rb.tt", destination_root("test", model_path, "models", "#{@singular}_test.rb")

          # Create controller
          template "templates/scaffold/controller.rb.tt", destination_root(app, "controllers", "#{@pluralized}.rb")
          template "templates/scaffold/controller_test.rb.tt", destination_root("test", app, "controllers", "#{@pluralized}_controller_test.rb")
          template "templates/scaffold/helper.rb.tt", destination_root(app, "helpers", "#{@pluralized}_helper.rb")

          # Create views
          views = ["index", "show"]
          if @create_full
            views << "new" << "edit"
          end

          views.each do |view|
            @view = view
            template "templates/scaffold/view.erb.tt", destination_root(app, "views", "#{@pluralized}", "#{@view}.erb")
          end

          # Create a migration unless skipped
          create_model_migration("create_#{@pluralized}", name, properties) unless options[:skip_migration]

          # Check if blueprints file exists and copy into place if not
          if !File.exist?(destination_root("test", "blueprints.rb"))
            template "templates/scaffold/blueprints.rb.tt", destination_root("test", "blueprints.rb")
          end

          # Insert into text_config.rb require blueprints.rb
          require_string = "\nrequire File.expand_path(File.dirname(__FILE__) + \"/blueprints.rb\")"
          test_config_contents = File.read(destination_root("test", "test_config.rb"))
          insert_into_file destination_root("test", "test_config.rb"), require_string, :after => "require File.expand_path('../../config/boot', __FILE__)"

          # Check if a blueprint for the model has already been created as
          # we don't want to wipe out an existing one
          blueprints_contents = File.read(destination_root("test", "blueprints.rb"))

          if !blueprints_contents.match("#{@model}.blueprint do")
            # build a string of properties to insert into the blueprint entry
            props = ""
            @properties.each do |property|
              values = property.split(":")
              faker = ""
              case values.last
                when "boolean"
                  faker += "true"
                when "datetime"
                  faker += "DateTime.now"
                when "integer"
                  faker += "1 + rand(100)"
                else
                  faker += "Faker::Lorem.sentence"
              end
              props += "\t#{values.first} { #{faker} }"
              props += "\n" unless property == @properties.last
            end

            # Format the blueprint entry
            model_blueprint = <<-MODEL
#{@model}.blueprint do
#{props}
end

            MODEL

            # Insert into blueprints.rb
            insert_into_file destination_root("test", "blueprints.rb"), model_blueprint, :before => "# END blueprints"
          else
            say "Blueprints entry already exists for '#{@singular}'", :yellow
          end

          say "Scaffold generation for '#{name}' in app '#{app}' completed", :green
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)", :red
        end
      end

    end # Scaffold
  end # Generators
end # Padrino