# Flexcon

Flexible consignment of arguments to lambdas using scopes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexcon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flexcon

## Usage

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Flexcon

## Basic Usage

Given a scope which could be an array, a hash, an object, or a proc - dispatch attributes of the scope into lambdas:

```ruby
array_scope = ['John', 'Doe', 'Acme Corporation']
hash_scope = { last_name: 'Doe', first_name: 'John', company: 'Acme Corporation' }
object_scope = OpenStruct.new(hash_scope)

full_name = lambda do |first_name, last_name|
  "#{first_name} #{last_name}"
end

employee = lambda do |first_name, last_name, company|
  "#{first_name} #{last_name} of #{company}"
end

# The following returns 'John Doe'
Flexcon.dispatch(array_scope, full_name)
Flexcon.dispatch(hash_scope, full_name)
Flexcon.dispatch(object_scope, full_name)

# The following returns 'John Doe of Acme Corporation' 
Flexcon.dispatch(array_scope, employee)
Flexcon.dispatch(hash_scope, employee)
Flexcon.dispatch(object_scope, employee)

# The following returns "['user', 'student', 'university']"
proc_scope = -> () do
  {
    models: [:user, :student, :university],
    api: -> (params) do
      params.to_json
    end
  }
end

api_wrapper = lambda do |api, models| 
  api.call(models)
end

Flexcon.dispatch(proc_scope, api_wrapper)
```

## Advanced Usage

If the method signature needed for certain functions are difficult to predict, instead of enforcing a single method signature, allow methods to ask for what they need from a scope.  

```ruby
class Operation
  def initialize
    @steps = []
    @named = {}
  end

  def step(name, &block)
    @steps << block
    @named[name] = block
  end

  def call(scope)
    @steps.each do |step|
      Flexcon.dispatch(scope, step)
    end
  end
end

class Scope
  attr_accessor :params, :models

  def initialize(params={})
    self.params = params
    self.models = {}
  end
end

op = Operation.new

op.step :find_or_init_user do |params, models|
  user = User.find_by(email: params[:user][:email])
  user ||= User.new(params[:user])

  models[:user] = user
end

op.step :find_or_init_student do |params, models|
  student = Student.find_or_initialize_by(user: models[:user], university_id: params[:university_id])
  student.assign_attributes(params[:student])

  models[:student] = student
end

op.step :save_user do |models|
  models[:user].save!
end

op.step :save_student do |models|
  models[:student].save!
end

op.call(Scope.new({}))
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rcpedro/flexcon.

