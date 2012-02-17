# Apply for Parse.com job web form

Backend-as-a-service company Parse is inviting potential hires to apply
via its [Parse API](https://parse.com/jobs#api). A small web form application 
for sending JSON-formated post requests.

## Pre-requirements

* sinatra
* faraday
* thin

## Usage

Install pre-requirements:

    gem install bundler --pre  # (if not installed)
    bundle install

Use the Rackup script to launch the application:

    thin start -R config.ru -p 8080

or

    ruby myapp.rb -p 8080

## In the wild

* [ParseJobs development](https://github.com/zh/parsejobs)
* [ParseJobs site](http://parsejobs.herokuapp.com/) itself
