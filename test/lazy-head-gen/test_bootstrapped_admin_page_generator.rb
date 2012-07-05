require 'helper'

class Person
  def self.columns
    [:id, :name, :age, :email].map { |c| OpenStruct.new(:name => c) }
  end
end

class Page
  def self.columns
    [:id, :name, :body].map { |c| OpenStruct.new(:name => c) }
  end
end

describe "BootstrappedAdminPageGenerator" do

  def setup
    @apptmp = "#{Dir.tmpdir}/padrino-tests/#{UUID.new.generate}"
    `mkdir -p #{@apptmp}`
  end

  def teardown
    `rm -rf #{@apptmp}`
  end

  describe 'the bootstrapped admin page generator' do

    it 'should fail outside app root' do
      out, err = capture_io { generate(:bootstrapped_admin_page, 'foo', "-r=#{@apptmp}/sample_project") }
      assert_match(/not at the root/, out)
      assert_no_file_exists('/tmp/admin')
    end

    it 'should fail without argument and model' do
      capture_io { generate(:project, 'sample_project', "-r=#{@apptmp}", '-d=activerecord') }
      capture_io { generate(:bootstrapped_admin_app, "-r=#{@apptmp}/sample_project") }
      assert_raises(Padrino::Admin::Generators::OrmError) { generate(:bootstrapped_admin_page, 'foo', "-r=#{@apptmp}/sample_project") }
    end

    it 'should correctly generate a new padrino admin application default renderer' do
      capture_io { generate(:project, 'sample_project', "-r=#{@apptmp}", '-d=activerecord','-e=erb', '-a mysql') }
      capture_io { generate(:bootstrapped_admin_app, "-r=#{@apptmp}/sample_project") }
      capture_io { generate(:model, 'person', "name:string", "age:integer", "email:string", "-r=#{@apptmp}/sample_project") }
      capture_io { generate(:bootstrapped_admin_page, 'person', "-r=#{@apptmp}/sample_project") }
      assert_file_exists "#{@apptmp}/sample_project/admin/controllers/people.rb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/_form.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/edit.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/index.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/new.erb"
      %w(name age email).each do |field|
        assert_match_in_file "label :#{field}", "#{@apptmp}/sample_project/admin/views/people/_form.erb"
        assert_match_in_file "text_field :#{field}", "#{@apptmp}/sample_project/admin/views/people/_form.erb"
      end
      assert_match_in_file "role.project_module :people, '/people'", "#{@apptmp}/sample_project/admin/app.rb"
      assert_match_in_file "elsif Padrino.env == :development && params[:bypass]", "#{@apptmp}/sample_project/admin/controllers/sessions.rb"
      assert_match_in_file "check_box_tag :bypass", "#{@apptmp}/sample_project/admin/views/sessions/new.erb"
    end

    it "should store and apply session_secret" do
      capture_io { generate(:project, 'sample_project', "-r=#{@apptmp}", '-d=activerecord','-e=erb') }
      assert_match_in_file(/set :session_secret, '[0-9A-z]*'/, "#{@apptmp}/sample_project/config/apps.rb")
    end

    it 'should correctly generate a new padrino admin application with multiple models' do
      capture_io { generate(:project, 'sample_project', "-r=#{@apptmp}", '-d=activerecord','-e=erb', '-a mysql') }
      capture_io { generate(:bootstrapped_admin_app, "-r=#{@apptmp}/sample_project") }
      capture_io { generate(:model, 'person', "name:string", "age:integer", "email:string", "-r=#{@apptmp}/sample_project") }
      capture_io { generate(:model, 'page', "name:string", "body:string", "-r=#{@apptmp}/sample_project") }
      capture_io { generate(:bootstrapped_admin_page, 'person', 'page', "-r=#{@apptmp}/sample_project") }
      # For Person
      assert_file_exists "#{@apptmp}/sample_project/admin/controllers/people.rb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/_form.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/edit.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/index.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/people/new.erb"
      %w(name age email).each do |field|
        assert_match_in_file "label :#{field}", "#{@apptmp}/sample_project/admin/views/people/_form.erb"
        assert_match_in_file "text_field :#{field}", "#{@apptmp}/sample_project/admin/views/people/_form.erb"
      end
      assert_match_in_file "role.project_module :people, '/people'", "#{@apptmp}/sample_project/admin/app.rb"
      # For Page
      assert_file_exists "#{@apptmp}/sample_project/admin/controllers/pages.rb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/pages/_form.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/pages/edit.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/pages/index.erb"
      assert_file_exists "#{@apptmp}/sample_project/admin/views/pages/new.erb"
      %w(name body).each do |field|
        assert_match_in_file "label :#{field}", "#{@apptmp}/sample_project/admin/views/pages/_form.erb"
        assert_match_in_file "text_field :#{field}", "#{@apptmp}/sample_project/admin/views/pages/_form.erb"
      end
      assert_match_in_file "role.project_module :pages, '/pages'", "#{@apptmp}/sample_project/admin/app.rb"
    end
  end
end
