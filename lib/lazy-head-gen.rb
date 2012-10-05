begin
  require 'padrino-gen'
  Padrino::Generators.load_paths << Dir[File.dirname(__FILE__) + '/lazy-head-gen/{admin_controller_test,scaffold}.rb']
rescue LoadError
  # Fail silently
end

module LazyHeadGen
  # Allows testing as a logged in admin user
  #
  # param [Account] account - The account to attempt login with
  def login_as(account, password = "password", path = "/admin/sessions/create")
    post path, {
      :email => account.email, :password => password
    }
    follow_redirect!
  end

  alias :login_as_admin :login_as

  # Standard assertions to test when an admin user is not logged in
  # and trys to view an admin page
  #
  def assert_admin_not_logged_in
    assert !last_response.ok?
    assert_equal 302, last_response.status
    assert last_response.original_headers["Location"].include?(Admin.url(:sessions, :new))
  end
end