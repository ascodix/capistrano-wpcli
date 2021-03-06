# Capistrano::Wpcli

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/capistrano/wpcli`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Sur windows installer 7zip et positionner la variable d'environement C:\Compression\7-Zip

Add this line to your application's Gemfile:

```ruby
gem 'windows-capistrano-wpcli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install windows-capistrano-wpcli

## Usage

Add to Capfile :

```ruby
require 'windows/capistrano/wpcli'
```

### Available commands

Here's a list of all available commands for wp-deploy. They must all be prefixed by `bundle exec cap <environment>`.

```
$ deploy                      # Deploy the project to a given environment
$ set :wpcli_local_url        # Setup your url locally
$ set :wpcli_remote_url       # Setup your url remote
$ set :wpcli_remote_tmp_dir   # Setup your remote tmp dir
$ set :wpcli_local_backup_dir # Setup your local backup dir

$ wpcli:db:push            # Override the remote environment's database with your local copy. Will also do a 'search and replace' for the site URLs.
$ wpcli:db:pull            # Override the local database with your remote environment's copy. Will also do a 'search and replace' for the site URLs.
```

## Example

```
cap production wpcli:db:push
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-wpcli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Capistrano::Wpcli project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/capistrano-wpcli/blob/master/CODE_OF_CONDUCT.md).

## Prérequis

### Installation de wp-cli

Copier les fichiers dans un répertoire et postionner une variable d'environnement sur ce répertoire

### Installation de 7zip

Installer 7zip en installant l'exécutable présent sur le lien psuivant [7zip](https://www.7-zip.org/download.html).

Puis rajouter son exécutable au PATH (par exemple C:\Compression\7-Zip)

## Livraison

```
gem build windows-capistrano-wpcli.gemspec

gem push windows-capistrano-wpcli-X.X.XX.gem
```