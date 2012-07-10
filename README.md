# lazy-head-gen

lazy-head-gen provides some extra generators for the [Padrino](https://github.com/padrino/padrino-framework) framework.

The generators are hard wired to use ActiveRecord and MiniTest, as that is the options I normally use in development at [Head](http://www.headlondon.com).

## Installation

```
gem install lazy-head-gen
```

In a Gemfile:

```ruby
gem 'lazy-head-gen', :group => [:development, :test]
```

Padrino gotcha: You'll need to put the `gem 'lazy-head-gen'` requirement *after* `gem 'padrino'` in your Gemfile.
lazy-head-gen depends on Padrino being loaded before it can do it's stuff.

Also you will need to add this gem for both :development and :test groups in your Gemfile. There are a few bundled test helper functions and assertions which are used by the test files that are generated.

## Usage

### Admin Controller Tests Generator

Generates a fully tested admin controller test for the 6 CRUD actions of a standard Padrino admin controller.

**Usage:**

```
padrino g admin_controller_test [name]
```

**Options:**

-r, [--root=ROOT] The root destination. Default: .

**Example:**

```
padrino g admin_controller_tests products
```

### Scaffold Generator

Generates a fully tested Padrino resource scaffold

**Usage:**

```
padrino g scaffold [name]
```

**Options:**

-r, [--root=ROOT] The root destination. Default: .

-s, [--skip-migration] Specify whether to skip generating a migration

-a, [--app-path=APP_PATH] The application destination path. Default: /app

-m, [--model-path=MODEL_PATH] he model destination path. Default: .

-c, [--create-full-actions] Specify whether to generate basic (index and show) or full (index, show, new, create, edit, update and delete) actions.

**Example:**

```
padrino g scaffold Product title:string summary:text quantity:integer available_from:datetime display:boolean -c
```

## Tests

### Built in assertions and test helpers

First off you will need to add this line to your test_config.rb file, after you have required boot.rb.

```
include LazyHeadGen
```

This will allow you to access the couple of test helpers that are used in the generated tests.

TODO: list test helper methods.

### blueprints.rb

The scaffold and admin_controller_test generators are reliant on you using a blueprints.rb file.

## To Do List

* Finish README - Built in assertions and test helpers
* Add form output to the scaffold generator
* Add documentation for testing gem dependencies

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