# RspecDatabaseHelper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rspec_database_helper`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_database_helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_database_helper
    
## Configuration

Include helpers into RSpec

```ruby
# spec/rails_helper.rb

RSpec.configure do |config|
  config.include RspecDatabaseHelper
end
```

## Usage

You can group `FactoryBot.create` definitions under `database` helper which supports handy syntax

```ruby
# user(:user, name: 'Bob') translates to let(:user) { FactoryBot.create(:user, name: 'Bob') }
# user!(:user, name: 'Bob') translates to let!(:user) { FactoryBot.create(:user, name: 'Bob') }
# user_list(:user, name: 'Bob', 3) translates to let(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
# user_list!(:user, name: 'Bob', 3) translates to let!(:user) { FactoryBot.create_list(:user, 3, name: 'Bob') }
#
RSpec.describe 'Subject' do
  database do
    company2!(:company, name: name, domain_name: domain, location: location_name)
    company3!(:company, name: name2, domain_name: domain, location: location_name)
    order1!(:order, :ordered, :with_items, items_count: 1, status: IN_QC, company_id: company3.id, delivered_at: Time.zone.now)
    order2!(:order, :ordered, :with_items, items_count: 1, status: COMPLETED, company_id: company3.id, delivered_at: Time.zone.now, order_date: (Time.zone.now - 1.day))
    order3!(:order, :ordered, :with_items, items_count: 1, status: NOT_READY, company_id: company3.id)
  end

  it 'has access to variables' do
    # You can access objects here
    # Don't forget to reload after changes
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec_database_helper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RspecDatabaseHelper project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rspec_database_helper/blob/master/CODE_OF_CONDUCT.md).
