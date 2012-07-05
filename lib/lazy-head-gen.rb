begin
  require 'padrino-gen'
  Padrino::Generators.load_paths << Dir[File.dirname(__FILE__) + '/lazy-head-gen/{bootstrapped_admin_app,bootstrapped_admin_page,admin_controller_test,scaffold}.rb']
rescue LoadError
  # Fail silently
end

module LazyHeadGen

  # Allows testing as a logged in admin user
  #
  # param [Account] account - The account to attempt login with
  def login_as_admin(account)
    post "/admin/sessions/create", {
      :email => account.email, :password => "password"
    }
    follow_redirect!
  end

  # Standard assertions to test when an admin user is not logged in
  # and trys to view an admin page
  #
  def assert_admin_not_logged_in
    assert !ok?
    assert_equal 302, status
    assert_equal "http://example.org/admin/sessions/new", location
  end

  # Assertions to test when an admin user is not logged in
  # and trys to call a destroy action
  #
  def assert_admin_destroy_not_logged_in
    assert !ok?
    assert_equal 405, status
    assert_nil location
  end

  # Some shorthands for last_request and last_response varibles
  #
  def path
    last_request.path
  end

  def session
    last_request.env['rack.session']
  end

  def body
    last_response.body
  end

  def status
    last_response.status
  end

  def location
    last_response.original_headers["Location"]
  end

  def ok?
    last_response.ok?
  end

  # A factory which we can use to build objects which are a bit more complex or
  # which require special setup which can't be done by Machinist without a bit of
  # help.
  #
  module Factory
    class << self

      def make_admin
        account = Account.make!
        account.save!
        account
      end

    end
  end
end