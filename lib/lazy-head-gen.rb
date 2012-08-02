begin
  require 'padrino-gen'
  Padrino::Generators.load_paths << Dir[File.dirname(__FILE__) + '/lazy-head-gen/{bootstrapped_admin_app,admin_controller_test,scaffold}.rb']
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
    assert !last_response.ok?
    assert_equal 302, last_response.status
    assert_equal "http://example.org/admin/sessions/new", last_response.original_headers["Location"]
  end

  def admin_url(*path)
    url = generate_url_for(*path)
    Admin.url(*url)
  end

  # Generates a valid Padrino url from unstructured input.
  #
  # We could just do e.g. App.url(:articles_index, :id => 1).
  #
  # This allows us to easily generate something like:
  #   url = generate_url_for(:articles, :index, :id => 1)
  #   App.url(*url)
  #
  def generate_url_for(*path)
    error = "Calm down there, buddy. You need at least 2 path params."
    raise error if path.length < 2

    if path.last.is_a?(Hash)
      params = path.pop
    end

    joined = path.length >= 2 ? path.join("_").to_sym : path
    url = ([] << joined << params).flatten.reject { |c| c.nil? }
  end


  # Removing due to conflicts when testing.
  #
  # def path
  #   last_request.path
  # end

  # def session
  #   last_request.env['rack.session']
  # end

  # def body
  #   last_response.body
  # end

  # def status
  #   last_response.status
  # end

  # def location
  #   last_response.original_headers["Location"]
  # end

  # def ok?
  #   last_response.ok?
  # end
end