# Rubocop Config Updater

Rubocop requires a lot of changes to its config if you didn't update it for a long time.
That's why I wrote this gem, because I was tired of manually changing the configuration file.
There is already [mry gem](https://github.com/pocke/mry) that solves the same problem, but it's a bit outdated.

This gem handles rubocop's stderr output, therefore it won't shouldn't get outdated. More info about how this gem works and what kind of errors it deals with, can be found in the section [#how-it-works](#how-it-works)

## Installation

Install

Add this line to your application's Gemfile:

```ruby
gem 'rubocop_config_updater', require: false
```

And then execute:

```sh
bundle install
```

Or **preferred** install it yourself as:

```sh
gem install rubocop_config_updater
```

After usage you can uninstall with:

```sh
gem cleanup rubocop_config_updater
```

## Usage

```sh
Usage: rubocop_config_updater [options]
    -c, --config PATH                Rubocop config path, i.e. .rubocop.yml
        --rubocop COMMAND            Rubocop command, i.e. bundle exec rubocop
    -v, --version
```

## How it works

This gem runs a command against rubocop and collects errors from STDERR, which are used to update rubocop's configuration file.
If you are interested in Rubocop's code responsible for the above mentioned errors, here is a link to Rubocop's [config_obsoletion class](https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/config_obsoletion.rb)

### Errors that are solved

- Renamed cops  
  `Naming/UncommunicativeMethodParamName` will be changed to `Naming/MethodParameterName`
- Moved cops  
  `Security/Eval` will be changed to `Lint/Eval`
- Renamed parameters  
  `SafeMode` will be changed to `SafeAutoCorrect`
- Missing department  
  `MethodLength` will be changed to `Metrics/MethodLength`

### Errors that you have to manually solve

- Removed cops
- Splitted cops
- Obsolete parameters

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/adamzapasnik/rubocop_config_updater](https://github.com/adamzapasnik/rubocop_config_updater).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
