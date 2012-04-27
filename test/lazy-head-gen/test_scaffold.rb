require 'helper'

describe "Scaffold Generator" do
  def setup
    @app_tmp = "#{Dir.tmpdir}/lazy-head-gen-tests/#{UUID.new.generate}"
    capture_io { FileUtils.mkdir_p(@app_tmp) }
    @project_name = "sample_project"
    @project_dir = "#{@app_tmp}/#{@project_name}"
    @sub_app = "sub"
  end

  def teardown
    `rm -rf #{Dir.tmpdir}/lazy-head-gen-tests`
  end

  describe "when generating a new scaffold" do
    it "should fail outside of the app root" do
      out, err = capture_io { generate(:scaffold, 'demo_items') }
      assert_match(/not at the root/, out)
    end

    describe "with a project that doesn't have an orm set" do
      before do
        capture_io { generate(:project, @project_name, "--root=#{@app_tmp}", '-e=erb', '-t=minitest') }
        @out, @err = capture_io { generate(:scaffold, 'demo_items', "-r=#{@project_dir}") }
      end

      it "should fail with a no orm error" do
        assert_match(/You need an ORM adapter to create this scaffold's model/, @out)
      end
    end

    describe "with a project" do
      before do
        create_project(@app_tmp, @project_name)
      end

      describe "and using standard app and model directories" do
        before do
          @out, @err = capture_io { generate(:scaffold, 'demo_items', "title:string", "summary:text", "available:datetime", "instock:boolean", "number:integer", "-r=#{@project_dir}") }
        end

        it "should create a model file" do
          path = "#{@project_dir}/models/demo_item.rb"
          assert_file_exists(path)
          assert_match_in_file(/class DemoItem < ActiveRecord::Base/, path)
        end

        it "should create a model test file" do
          path = "#{@project_dir}/test/models/demo_item_test.rb"
          assert_file_exists(path)
          assert_match_in_file(/describe "DemoItem Model" do/, path)
          assert_match_in_file(/@demo_item = DemoItem.new/, path)
          assert_match_in_file(/refute_nil @demo_item/, path)
        end

        it "should create a controller file" do
          path = "#{@project_dir}/app/controllers/demo_items.rb"
          assert_file_exists(path)
          assert_match_in_file(/SampleProject.controllers :demo_items do/, path)
          assert_match_in_file(/get :index do/, path)
          assert_match_in_file(/get :show, :with => :id do/, path)
          assert_no_match_in_file(/get :new do/, path)
          assert_no_match_in_file(/post :create do/, path)
          assert_no_match_in_file(/get :edit, :with => :id do/, path)
          assert_no_match_in_file(/put :update, :with => :id do/, path)
          assert_no_match_in_file(/delete :destroy, :with => :id do/, path)
        end

        it "should create a controller test file" do
          path = "#{@project_dir}/test/app/controllers/demo_items_controller_test.rb"
          assert_file_exists(path)
          assert_match_in_file(/describe "DemoItemsController" do/, path)
          assert_match_in_file(/GET index/, path)
          assert_match_in_file(/GET show/, path)
          assert_no_match_in_file(/GET new/, path)
          assert_no_match_in_file(/POST create/, path)
          assert_no_match_in_file(/GET edit/, path)
          assert_no_match_in_file(/PUT update/, path)
          assert_no_match_in_file(/DELETE destroy/, path)
        end

        it "should create a helper file" do
          path = "#{@project_dir}/app/helpers/demo_items_helper.rb"
          assert_file_exists(path)
          assert_match_in_file(/SampleProject.helpers do/, path)
        end

        it "should create an index view" do
          path = "#{@project_dir}/app/views/demo_items/index.erb"
          assert_file_exists(path)
          assert_match_in_file(/This is the index page/, path)
        end

        it "should create a show view" do
          path = "#{@project_dir}/app/views/demo_items/show.erb"
          assert_file_exists(path)
          assert_match_in_file(/This is the show page/, path)
        end

        it "should create a database migration" do
          path = "#{@project_dir}/db/migrate/001_create_demo_items.rb"
          assert_file_exists(path)
          assert_match_in_file(/class CreateDemoItems < ActiveRecord::Migration/, path)
          assert_match_in_file(/create_table :demo_items/, path)
          assert_match_in_file(/t.string :title/, path)
          assert_match_in_file(/t.text :summary/, path)
          assert_match_in_file(/t.datetime :available/, path)
          assert_match_in_file(/t.boolean :instock/, path)
          assert_match_in_file(/t.integer :number/, path)
          assert_match_in_file(/t.timestamps/, path)
          assert_match_in_file(/drop_table :demo_items/, path)
        end

        it "should copy and format the blueprints.rb file" do
          path = "#{@project_dir}/test/blueprints.rb"
          assert_file_exists(path)
          assert_match_in_file(/DemoItem.blueprint do/, path)
          assert_match_in_file(/title \{ Faker::Lorem.sentence \}/, path)
          assert_match_in_file(/summary \{ Faker::Lorem.sentence \}/, path)
          assert_match_in_file(/available \{ DateTime.now \}/, path)
          assert_match_in_file(/instock \{ true \}/, path)
          assert_match_in_file(/number \{ 1 \+ rand\(100\) \}/, path)
        end

        it "should require the blueprints file in test_config.rb" do
          path = "#{@project_dir}/test/test_config.rb"
          assert_match_in_file("require File.expand_path(File.dirname(__FILE__) + \"\/blueprints.rb\")", path)
        end

        it "should let you know everything is done" do
          assert_match "Scaffold generation for 'demo_items' in app '/app' completed", @out
        end
      end

      describe "and using the create_full flag" do
        before do
          @out, @err = capture_io { generate(:scaffold, 'demo_items', "title:string", "summary:text", "available:datetime", "instock:boolean", "number:integer", "-r=#{@project_dir}", "-c=true") }
        end

        it "should create a full controller file" do
          path = "#{@project_dir}/app/controllers/demo_items.rb"
          assert_file_exists(path)
          assert_match_in_file(/SampleProject.controllers :demo_items do/, path)
          assert_match_in_file(/get :index do/, path)
          assert_match_in_file(/get :show, :with => :id do/, path)
          assert_match_in_file(/get :new do/, path)
          assert_match_in_file(/post :create do/, path)
          assert_match_in_file(/get :edit, :with => :id do/, path)
          assert_match_in_file(/put :update, :with => :id do/, path)
          assert_match_in_file(/delete :destroy, :with => :id do/, path)
        end

        it "should create a full controller test file" do
          path = "#{@project_dir}/test/app/controllers/demo_items_controller_test.rb"
          assert_file_exists(path)
          assert_match_in_file(/describe "DemoItemsController" do/, path)
          assert_match_in_file(/GET index/, path)
          assert_match_in_file(/GET show/, path)
          assert_match_in_file(/GET new/, path)
          assert_match_in_file(/POST create/, path)
          assert_match_in_file(/GET edit/, path)
          assert_match_in_file(/PUT update/, path)
          assert_match_in_file(/DELETE destroy/, path)
        end
      end

      describe "and using the skip create migration flag" do
        before do
          @out, @err = capture_io { generate(:scaffold, 'demo_items', "title:string", "summary:text", "available:datetime", "instock:boolean", "number:integer", "-r=#{@project_dir}", "-s=true") }
        end

        it "should not create a database migration" do
          path = "#{@project_dir}/db/migrate/001_create_demo_items.rb"
          assert_no_file_exists(path)
        end
      end

      describe "and using a different app path" do
        before do
          capture_io { generate(:app, @sub_app, "--root=#{@project_dir}") }
          @out, @err = capture_io { generate(:scaffold, 'demo_items', "title:string", "summary:text", "available:datetime", "instock:boolean", "-r=#{@project_dir}", "-a=#{@sub_app}") }
        end

        it "should create a controller file" do
          path = "#{@project_dir}/#{@sub_app}/controllers/demo_items.rb"
          assert_file_exists(path)
          assert_match_in_file(/Sub.controllers :demo_items do/, path)
          assert_match_in_file(/get :index do/, path)
          assert_match_in_file(/get :show, :with => :id do/, path)
          assert_no_match_in_file(/get :new do/, path)
          assert_no_match_in_file(/post :create do/, path)
          assert_no_match_in_file(/get :edit, :with => :id do/, path)
          assert_no_match_in_file(/put :update, :with => :id do/, path)
          assert_no_match_in_file(/delete :destroy, :with => :id do/, path)
        end

        it "should create a controller test file" do
          path = "#{@project_dir}/test/#{@sub_app}/controllers/demo_items_controller_test.rb"
          assert_file_exists(path)
          assert_match_in_file(/describe "DemoItemsController" do/, path)
          assert_match_in_file(/GET index/, path)
          assert_match_in_file(/GET show/, path)
          assert_no_match_in_file(/GET new/, path)
          assert_no_match_in_file(/POST create/, path)
          assert_no_match_in_file(/GET edit/, path)
          assert_no_match_in_file(/PUT update/, path)
          assert_no_match_in_file(/DELETE destroy/, path)
        end

        it "should create a helper file" do
          path = "#{@project_dir}/#{@sub_app}/helpers/demo_items_helper.rb"
          assert_file_exists(path)
          assert_match_in_file(/Sub.helpers do/, path)
        end

        it "should create an index view" do
          path = "#{@project_dir}/#{@sub_app}/views/demo_items/index.erb"
          assert_file_exists(path)
          assert_match_in_file(/This is the index page/, path)
        end

        it "should create a show view" do
          path = "#{@project_dir}/#{@sub_app}/views/demo_items/show.erb"
          assert_file_exists(path)
          assert_match_in_file(/This is the show page/, path)
        end
      end

      describe "and using a different model path" do
        # TODO: Finish these tests when model route isn't hardcoded to "."
      end
    end
  end
end