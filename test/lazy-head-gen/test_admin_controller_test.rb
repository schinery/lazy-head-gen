require 'helper'

describe "AdminControllerTest generator" do
  def setup
    @app_tmp = "#{Dir.tmpdir}/lazy-head-gen-tests/#{UUID.new.generate}"
    capture_io { FileUtils.mkdir_p(@app_tmp) }
    @project_name = "sample_project"
    @project_dir = "#{@app_tmp}/#{@project_name}"
  end

  def teardown
    `rm -rf #{Dir.tmpdir}/lazy-head-gen-tests`
  end

  describe "when generating a new admin controller test" do
    it "should fail outside of the app root" do
      out, err = capture_io { generate(:admin_controller_test, 'demo_items') }
      assert_match(/not at the root/, out)
    end

    describe "with a project" do
      before do
        create_project(@app_tmp, @project_name)
      end

      it "should fail if the admin controller does not exist" do
        out, err = capture_io { generate(:admin_controller_test, 'demo_items', "-r=#{@project_dir}") }
        assert_match(/demo_items.rb does not exist/, out)
        assert_match(/padrino g admin_page DemoItem/, out)
        assert_no_file_exists("#{@project_dir}/test/admin/controllers/demo_items_controller_test.rb")
      end

      it "should create an admin controller test if the admin controller does exist" do
        # We are only interested in if the admin controller exists and if
        # so generate the tests, so am going to create a fake file to pass
        # the does file exist check in the generator
        FileUtils.mkdir_p("#{@project_dir}/admin/controllers")
        FileUtils.touch("#{@project_dir}/admin/controllers/demo_items.rb")

        out, err = capture_io { generate(:admin_controller_test, 'demo_items', "-r=#{@project_dir}") }
        assert_file_exists("#{@project_dir}/test/admin/controllers/demo_items_controller_test.rb")
        assert_match(/test\/admin\/controllers\/demo_items_controller_test.rb/, out)
        assert_match(/Admin controller tests generation for 'demo_items' completed/, out)
      end
    end
  end
end