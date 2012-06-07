# lazy-head-gen

Lazy Head Gen provides a couple of extra generators for the excellent [Padrino](https://github.com/padrino/padrino-framework) framework.

It is assuming that you are using ActiveRecord and MiniTest, as that is the options we normally use when developing at [Head](http://www.headlondon.com).

## Installation

```
gem install lazy-head-gen
```

In a Gemfile:

```ruby
gem 'lazy-head-gen', :group => [:development, :test]
```

Padrino gotcha: You'll need to put the `gem 'lazy-head-gen'` requirement *after* `gem 'padrino'` in your Gemfile.
Lazy Head Gen needs Padrino loaded before it can work.

Also you will need to add this gem for both :development and :test groups. This is because there are a couple of added test helper functions and assertions used by the output from the generators.

## Usage

There are currently 2 extra generators, scaffold and admin_controller_tests.

### Scaffold Generator

To generate a new scaffold:

```
padrino g scaffold ModelName property:type
```

For example to generate a scaffold for Products:

```
padrino g scaffold Product title:string summary:text quantity:integer available_from:datetime display:boolean
```

This will generate the following:

* A controller, helper and controller test for Products
* An index and show view for Products
* A model, model test and database migration for Product
* A blueprints file if one doesn't exist

It will also add:

* A reference to blueprints.rb to test_config.rb if required
* Add a Product blueprint and it's properties to the blueprints.rb file

### Admin Controller Tests Generator

To generate a new admin controller test:

```
padrino g admin_controller_tests ControllerName
```

Controller name should be the name of an existing admin controller.

For example to generate an admin controller test for products:

```
padrino g admin_controller_tests products
```

This will generate a fully tested admin controller test for the 6 CRUD routes of a standard Padrino admin controller.

## Extras

### Built in assertions and test helpers

TODO: Write about these

### blueprints.rb

If you already have a blueprints.rb file, the scaffold generator looks for *# END blueprints* as a marker to insert the generated models blueprint. This is a bit... well crap... but I currently haven't thought of another way to do it.

## To Do List

* Finish README
* See if there is a better way to do the blueprint inserts

## Contributing to lazy-head-gen

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 [Stuart Chinery](http://www.headlondon.com/who-we-are#stuart-chinery), [headlondon.com](http://www.headlondon.com)
See LICENSE.txt for further details.