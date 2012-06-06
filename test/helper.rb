ENV['PADRINO_ENV'] = 'test'
PADRINO_ROOT = File.dirname(__FILE__) unless defined? PADRINO_ROOT

require File.expand_path('../load_paths', __FILE__)
require 'minitest/autorun'
require 'rack/test'
require 'rack'
require 'uuid'
require 'thor/group'
require 'padrino-core/support_lite' unless defined?(SupportLite)
require 'padrino-admin'
require File.dirname(__FILE__) + '/../lib/lazy-head-gen.rb'
begin; require 'turn/autorun'; rescue LoadError; end
require 'ruby-debug'

Padrino::Generators.load_components!

module Kernel
  def load_fixture(file)
    Object.send(:remove_const, :Account) if defined?(Account)
    Object.send(:remove_const, :Category) if defined?(Category)
    file += ".rb" if file !~ /.rb$/
    capture_io { load File.join(File.dirname(__FILE__), "fixtures", file) }
  end
end

#class Class
# # Allow assertions in request context
# include MiniTest::Assertions
#end

class MiniTest::Unit::TestCase
  include Rack::Test::Methods

  # Sets up a Sinatra::Base subclass defined with the block
  # given. Used in setup or individual spec methods to establish
  # the application.
  def mock_app(base=Padrino::Application, &block)
    @app = Sinatra.new(base, &block)
    @app.send :include, MiniTest::Assertions
    @app.register Padrino::Helpers
  end

  def app
    Rack::Lint.new(@app)
  end

  # Creates a project and inserts lazy-head-gen reference into GemFile
  def create_project(app_tmp, project_dir)
    capture_io { generate(:project, project_dir, "--root=#{app_tmp}", '-d=activerecord', '-e=erb', '-t=minitest') }

    # Hitting it with the command line hammer as I was having problems getting
    # Thor's insert_into_file to work. Yes it is dirty!
    gem_path = File.expand_path(File.join(File.dirname(__FILE__)))
    capture_io { `echo "gem 'lazy-head-gen', :path => '#{gem_path}'" >> #{app_tmp}/#{project_dir}/GemFile` }
  end

  # generate(:admin_app, "-r=#{@apptmp}/sample_project")
  def generate(name, *params)
    "Padrino::Generators::#{name.to_s.camelize}".constantize.start(params)
  end

  # Assert_file_exists('/tmp/app')
  def assert_file_exists(file_path)
    assert File.exist?(file_path), "File at path '#{file_path}' does not exist!"
  end

  # Assert_no_file_exists('/tmp/app')
  def assert_no_file_exists(file_path)
    assert !File.exist?(file_path), "File should not exist at path '#{file_path}' but was found!"
  end

  # Asserts that a file matches the pattern
  def assert_match_in_file(pattern, file)
    File.exist?(file) ? assert_match(pattern, File.read(file)) : assert_file_exists(file)
  end

  def assert_no_match_in_file(pattern, file)
    File.exists?(file) ? refute_match(pattern, File.read(file)) : assert_file_exists(file)
  end

  # Delegate other missing methods to response.
  # def method_missing(name, *args, &block)
  #   if response && response.respond_to?(name)
  #     response.send(name, *args, &block)
  #   else
  #     super(name, *args, &block)
  #   end
  # end

  # alias :response :last_response
end