begin
  require 'padrino-gen'
  Padrino::Generators.load_paths << Dir[File.dirname(__FILE__) + '/lazy-head-gen/{admin_controller_tests,scaffold}.rb']
rescue LoadError
  # Fail silently
end