Heartcheck
==============

[![Build Status](https://travis-ci.org/locaweb/heartcheck.svg)](https://travis-ci.org/locaweb/heartcheck)

Check your applications' heart.

About
-----

### Endpoint JSON documentation:

https://github.com/locaweb/heartcheck/wiki/Endpoint-Json

## How to setup

1. Include the gem in your Gemfile:

    ```
    gem 'heartcheck'
    ```

2. Install the gem:

    ```
    bundle install
    ```

3. Generate some required files according to the framework you are using:

    ```
    heartcheck rails
    heartcheck padrino
    heartcheck sinatra
    ```

4. After that, follow the instructions, edit the generated files and restart your server.

5. Done! Now you are able to access `[host]/monitoring` and check the monitoring JSON!

## Routes
* `[host]/monitoring`
    * To check if the app and its integrations are avaiable;
    * Directed for verifying the app SLA;
* `[host]/monitoring/info`
    * To view some informations that you can configure;
    * Directed for availability check from load balanced and get info about the installed app;
* `[host]/monitoring/functional`
    * To check if the app is healty (no async job failed and other checks that aren't related to app availability);
    * Directed for verifying consistency problems within the app;
* `[host]/monitoring/dev`
    * Directed for the development team;
    * It's run the essential and functional checks;
* `[host]/monitoring/health_check`
    * To check if the app is up and running

## How to use

You can see how to use in template that is generated when install:
https://github.com/locaweb/heartcheck/blob/master/lib/heartcheck/generators/templates/config.rb

## Git tags

Don't forget to tag your work! After a merge request being accepted, run:

1 - (git tag -a "x.x.x" -m "") to create the new tag.
2 - (git push origin "x.x.x") to push the new tag to remote.

Follow the RubyGems conventions at http://docs.rubygems.org/read/chapter/7 to know how to increment the version number. Covered in more detail in http://semver.org/

## Merge requests acceptance

Don't forget to write tests to all your code. It's very important to maintain the codebase's sanity. Any merge request that doesn't have enough test coverage will be asked a revision
