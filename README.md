lazy-head-gen
=============

Lazy Head Gen is simply a couple of extra generators for the excellent [Padrino](https://github.com/padrino/padrino-framework) framework.

It is currently tied into assuming that you are using ActiveRecord and MiniTest, as that is what I normally use when developing at Head.

Installation:
-------------

```
gem install lazy-head-gen
```

In a Gemfile:

```ruby
gem 'lazy-head-gen'
```

Padrino gotcha: You'll need to put the `gem 'lazy-head-gen'` requirement *after* `gem 'padrino'` in your Gemfile.
Lazy Head Gen needs Padrino loaded before it can show up in a Gemfile.




Contributing to lazy-head-gen
-----------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Stuart Chinery, http://www.headlondon.com
See LICENSE.txt for further details.