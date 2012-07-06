# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "lazy-head-gen"
  gem.homepage = "http://github.com/sleepingstu/lazy-head-gen"
  gem.license = "MIT"
  gem.summary = %Q{Some extra generators for Padrino, using ActiveRecord and MiniTest.}
  gem.description = %Q{lazy-head-gen adds some extra generators to Padrino. Currently it assumes you are using ActiveRecord and MiniTest.}
  gem.email = "stuart.chinery@headlondon.com"
  gem.authors = ["Stuart Chinery"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new