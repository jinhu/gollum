gollum -- A wiki built on top of Git
====================================

## DESCRIPTION

Gollum is a simple wiki system built on top of Git that powers GitHub Wikis.

For a full description of gollum see https://github.com/github/gollum

This fork adds OAuth based user accounts, which means users can sign in using any OAuth service.

## OAuth Configuration

To configure OAuth either run `bin/gollum` which will create a yml file or, if you are using Rack, set `Precious::OAuth.config` in your _config.ru_ file. The required keys are `:service_name` (any name, appears on the sign in page), `:consumer_key`, `:consumer_secret` and `:server_url` (the root url of the OAuth server, e.g. `http://example.com`)

## Also

In order for this to work the OAuth module extracts the user's email address and name from the OAuth server. Right now this is implemented to work with http://cobot.me. Since any other OAuth service does this in a different way you have to overwrite the `Precious::OAuth#get_user_details` method, which should return a Hash that looks like: `{'name' => 'joe', 'email' => 'joe@doe.com'}`