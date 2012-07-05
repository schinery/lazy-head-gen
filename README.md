# lazy-head-gen

lazy-head-gen provides some extra generators for the excellent [Padrino](https://github.com/padrino/padrino-framework) framework.

It is assuming that you are using ActiveRecord and MiniTest, as that is the options we normally use in our development at [Head](http://www.headlondon.com).

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

Also you will need to add this gem for both :development and :test groups. There are a few bundled in test helper functions and assertions used by the test files outputted from the generators.

## Usage

### Bootstrapped Admin Generator

Generates a new Padrino Admin application with Twitter Bootstrapped integrated.

**Usage:**

```
padrino g bootstrapped_admin
```

**Options:**

-r, [--root=ROOT] The root destination. Default: .

-s, [--skip-migration]

-d, [--destroy]

-m, [--admin-model=ADMIN_MODEL] The name of model for access controlling. Default: Account

-a, [--app=APP] The model destination path. Default: .

**Example:**

```
padrino g bootstrapped_admin
```

### Bootstrapped Admin Page Generator

Generates a new Padrino Admin page with Twitter Bootstrapped integrated.

**Usage:**

```
padrino g bootstrapped_admin_page [model]
```

**Options:**

-r, [--root=ROOT] The root destination.

-s, [--skip-migration]

-d, [--destroy]

**Example:**

```
padrino g bootstrapped_admin_page product
```

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

TODO: Write about these

### blueprints.rb

The scaffold and admin_controller_test generators are reliant on you using a blueprints.rb file.

## To Do List

* Finish README - Built in assertions and test helpers
* Add form output to the scaffold generator

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