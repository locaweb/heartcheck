# Heartcheck

Heartcheck is a monitoring tool for Rack applications. It provides a DSL to
declare service checks and an URI that returns the status for each service.
With this gem you can monitor if your app has access to the database, a cache
service, an API, etc.

[![Build Status](https://travis-ci.org/locaweb/heartcheck.svg)](https://travis-ci.org/locaweb/heartcheck)
[![Code Climate](https://codeclimate.com/github/locaweb/heartcheck/badges/gpa.svg)](https://codeclimate.com/github/locaweb/heartcheck)
[![Ebert](https://ebertapp.io/github/locaweb/heartcheck.svg)](https://ebertapp.io/github/locaweb/heartcheck)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heartcheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heartcheck

## Usage

First generate the config file for the framework you are using:

    $ heartcheck rails
    $ heartcheck padrino
    $ heartcheck sinatra

Then edit the generated file by adding your checks on it and restart your
server. Now you should be able to make a HTTP request for `/monitoring` and
get a JSON response that contains the status for each monitored service.

The following environment variables are needed by heartcheck:

    HEARTCHECK_APP_NAME=MyApplicationName


### Using built-in checks

#### Firewall check

```ruby
Heartcheck.setup do |config|
  config.add :firewall do |c|
    c.add_service(host: 'domain.com', port: 80)
    c.add_service(host: 'domain.com', port: 80, timeout: 5) # Default timeout is 2 seconds
    c.add_service(url: 'https://domain.com')
    c.add_service(url: 'https://domain.com', proxy: 'http://proxy.domain.com')
  end
end
```

## HTTP Routes

#### Basic health check

To get the status for all services, make a HTTP request for the following URI:

    /monitoring

It will return a JSON response and a status for each service.

#### Functional status

Functional services are services essential for your application. You can get
their status using the following route:

    /monitoring/functional

#### Info route

This route returns custom information about your app. You can configure it to
return whatever information you want:

    /monitoring/info

#### Dev status

Returns some debugging information:

    /monitoring/dev

#### Very basic health check

Returns a simple `ok` if the app is running. It does not execute any configured
checks:

    /monitoring/health_check


#### General info and dependencies

Returns general application info and a list of dependencies' URIs, but executes no checking:

    /monitoring/inspect

## Plugins

* [ActiveRecord](https://github.com/locaweb/heartcheck-activerecord)
* [Cache](https://github.com/locaweb/heartcheck-cache)
* [Cas](https://github.com/locaweb/heartcheck-cas)
* [Redis](https://github.com/locaweb/heartcheck-redis)
* [Resque](https://github.com/locaweb/heartcheck-resque)
* [Sidekiq](https://github.com/locaweb/heartcheck-sidekiq)
* [Webservice](https://github.com/locaweb/heartcheck-webservice)

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/locaweb/heartcheck.
