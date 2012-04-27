source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "shoulda", ">= 0"
  gem "bundler", "~> 1.1.3"
  gem "jeweler", "~> 1.6.4"
  gem "simplecov", :require => false
  gem "rdoc"

  # From Padrino Framework
  if ENV['SINATRA_EDGE']
    puts "=> Using sinatra edge"
    gem "sinatra", :git => "git://github.com/sinatra/sinatra.git" # :path => "/Developer/src/Extras/sinatra"
  end
  gem "json",      ">= 1.5.3"
  gem "nokogiri",  ">= 1.4.4"
  gem "grit",      ">= 2.4.1"
  gem "rack",      ">= 1.3.0"
  gem "rake",      ">= 0.8.7"
  gem "yard",      ">= 0.7.2"
  gem "rack-test", ">= 0.5.0"
  gem "fakeweb",   ">= 1.2.8"
  gem "webrat",    ">= 0.5.1"
  gem "haml",      ">= 2.2.22"
  gem "erubis",    ">= 2.7.0"
  gem "slim",      ">= 0.9.2"
  gem "uuid",      ">= 2.3.1"
  gem "builder",   ">= 2.1.2"
  gem "bcrypt-ruby", :require => "bcrypt"
  platforms :mri_18 do
    # gem "rcov",         "~> 0.9.8"
    # gem "ruby-prof",    ">= 0.9.1"
    gem "system_timer", ">= 1.0"
  end
  platforms :jruby do
    gem "jruby-openssl"
  end
  gem "mocha",    "~>0.10.0"
  gem "minitest", "~>2.6.0"
  gem "lumberjack"

  gem 'ruby-debug'
end

gem 'padrino'
