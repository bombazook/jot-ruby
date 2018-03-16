# Jot::Ruby

Ruby wrapper for Joshua Tauberer's JOT project (https://github.com/JoshData/jot) – an operational transform (OT) javascript library. For now it is just a direct proxy to original implementation using Execjs (you may use any runtime you like, but I recommend mini_racer https://github.com/discourse/mini_racer).

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'jot-ruby'
gem 'mini_racer' # or 'therubyracer' for example
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jot-ruby

## Usage

```ruby
require 'jot/ruby'
```

### Basic JOT operations
- NO_OP - Creates operation that does nothing
- SET and LIST – General purpose operations
- MATH - Math ops
- SPLICE, ATINDEX, MAP - Strings and Arrays ops
- PUT, REM, APPLY - Object operations
- COPY - May not work as expected at this time according to https://github.com/JoshData/jot/issues/12

```ruby
# creating a new operation
Jot::Ruby.PUT("0", "1")
```

### General purpose methods
- opFromJSON - Creates an operation declared in json form
- deserialize - Creates an operation using it's serialized form
- diff - Creates a coplex op describes a list of operations to transform one object into another
```ruby
Jot::Ruby.diff({a: 1}, {b: 2}) # Returns an operation instance
```

### Operation instance methods
- isNoOp - Returns true or false according to op's functionalify
- toJSON - Returns a json view of operation
- apply - Gets an object and returns it's updated version
- serialize - Returns serialized version of operation
- simplify - Tries to reduce operation complexity
- drilldown - Returns operation describing it's subset ongiven key or index
- compose - Composes an operation with another one and returns another operation (i.e. LIST operation)
- rebase - receives another operation and raise an exception if there is a conflict, or may additionally receive initial version of document as second argument to make a conflictless rebase

```ruby
op = jot.LIST([jot.APPLY("title", jot.SPLICE(5, 3, "small")), jot.APPLY("count", jot.MATH('add', -10))])
op.apply({title: "It's big", count: 20}) # => {"title"=>"It's small", "count"=>10} 
```

### Additional info
Use same arguments format as original implementation does
For example, LIST operation receives an Array but not a list of arguments
```ruby
Jot::Ruby.LIST([
    Jot::Ruby.APPLY("title", Jot::Ruby.SPLICE(0, 5, "It's small")), 
    Jot::Ruby.APPLY("count", Jot::Ruby.MATH("add", 10))
]) # Works as expected
Jot::Ruby.LIST(
    Jot::Ruby.APPLY("title", Jot::Ruby.SPLICE(0, 5, "It's small")), 
    Jot::Ruby.APPLY("count", Jot::Ruby.MATH("add", 10))
)  # Raises a Jot::Ruby::Errors::ImplError exception
```

#### For further docs read https://github.com/JoshData/jot readme

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To build a new version of js implementation update a submodule first:

    $ git submodule init
    $ git submodule update --recursive

Install javascript dependencies (you should have a javscript runtime and Yarn installed):

    $ yarn install

rebuild build/jot.js using Rake command:

    $ rake build:webpack

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bombazook/jot-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jot::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bombazook/jot-ruby/blob/master/CODE_OF_CONDUCT.md).
