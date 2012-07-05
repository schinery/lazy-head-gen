module Padrino
  module Generators
    ##
    # Defines the generator for creating a new admin app.
    #
    class BootstrappedAdminApp < Thor::Group

      # Add this generator to our padrino-gen
      Padrino::Generators.add_generator(:bootstrapped_admin, self)

      # Define the source template root and themes.
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      # Defines the "banner" text for the CLI.
      def self.banner; "padrino g bootstrapped_admin"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators::Actions
      include Padrino::Generators::Admin::Actions

      desc "Description:\n\n\tpadrino g bootstrapped_admin - Generates a new Padrino Admin application with Twitter Bootstrapped integrated"

      class_option :skip_migration, :aliases => "-s", :default => false, :type => :boolean

      class_option :app, :aliases => "-a", :desc => "The model destination path", :default => '.', :type => :string

      class_option :root, :desc => "The root destination", :aliases => '-r', :default => ".", :type => :string

      class_option :destroy, :aliases => '-d', :default => false, :type => :boolean

      class_option :admin_model, :aliases => '-m', :desc => "The name of model for access controlling", :default => 'Account', :type => :string

      # Copies over the Padrino base admin application
      def create_admin
        self.destination_root = options[:root]
        if in_app_root?
          store_component_choice(:admin_renderer, :erb)

          self.behavior = :revoke if options[:destroy]

          empty_directory destination_root("admin")
          directory "templates/admin_app/app", destination_root("admin")
          directory "templates/admin_app/assets", destination_root("public", "admin")
          template  "templates/admin_app/app.rb.tt", destination_root("admin/app.rb")
          append_file destination_root("config/apps.rb"),  "\nPadrino.mount(\"Admin\").to(\"/admin\")"
          insert_middleware 'ActiveRecord::ConnectionAdapters::ConnectionManagement', 'admin'

          account_params = [
            options[:admin_model].underscore, "name:string", "surname:string", "email:string", "crypted_password:string", "role:string",
            "-a=#{options[:app]}",
            "-r=#{options[:root]}"
          ]

          account_params << "-s" if options[:skip_migration]
          account_params << "-d" if options[:destroy]

          Padrino::Generators::Model.start(account_params)
          column = Struct.new(:name, :type)
          columns = [:id, :name, :surname, :email].map { |col| column.new(col) }
          column_fields = [
            { :name => :name,                  :field_type => :text_field },
            { :name => :surname,               :field_type => :text_field },
            { :name => :email,                 :field_type => :text_field },
            { :name => :password,              :field_type => :password_field },
            { :name => :password_confirmation, :field_type => :password_field },
            { :name => :role,                  :field_type => :text_field }
          ]

          admin_page = Padrino::Generators::BootstrappedAdminPage.new([options[:admin_model].underscore], :root => options[:root], :destroy => options[:destroy])
          admin_page.default_orm = Padrino::Admin::Generators::Orm.new(options[:admin_model].underscore, orm, columns, column_fields)
          admin_page.invoke_all

          template "templates/admin_app/account/activerecord.rb.tt", destination_root(options[:app], "models", "#{options[:admin_model].underscore}.rb"), :force => true

          if File.exist?(destination_root("db/seeds.rb"))
            run "mv #{destination_root('db/seeds.rb')} #{destination_root('db/seeds.old')}"
          end
          template "templates/admin_app/account/seeds.rb.tt", destination_root("db/seeds.rb")

          empty_directory destination_root("admin/controllers")
          empty_directory destination_root("admin/views")
          empty_directory destination_root("admin/views/base")
          empty_directory destination_root("admin/views/layouts")
          empty_directory destination_root("admin/views/sessions")

          template "templates/admin_app/#{ext}/app/base/index.#{ext}.tt",          destination_root("admin/views/base/index.#{ext}")
          template "templates/admin_app/#{ext}/app/layouts/application.#{ext}.tt", destination_root("admin/views/layouts/application.#{ext}")
          template "templates/admin_app/#{ext}/app/sessions/new.#{ext}.tt",        destination_root("admin/views/sessions/new.#{ext}")

          model_singular = options[:admin_model].underscore
          model_plural = model_singular.pluralize

          add_project_module model_plural
          require_dependencies('bcrypt-ruby', :require => 'bcrypt')
          gsub_file destination_root("admin/views/#{model_plural}/_form.#{ext}"), "f.text_field :role, :class => :text_field", "f.select :role, :options => access_control.roles"
          gsub_file destination_root("admin/controllers/#{model_plural}.rb"), "if #{model_singular}.destroy", "if #{model_singular} != current_account && #{model_singular}.destroy"
          return if self.behavior == :revoke

          instructions = []
          instructions << "Run 'bundle install'"
          instructions << "Run 'padrino rake ar:migrate'"
          instructions << "Run 'padrino rake seed'"
          instructions << "Visit the admin panel in the browser at '/admin'"
          instructions.map! { |i| "  #{instructions.index(i)+1}) #{i}" }

          say
          say "="*65, :green
          say "The admin panel has been mounted! Next, follow these steps:", :green
          say "="*65, :green
          say instructions.join("\n")
          say "="*65, :green
          say
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)"
        end
      end
    end # AdminApp
  end # Generators
end # Padrino
