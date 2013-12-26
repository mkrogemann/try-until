try-until
=========

[![Build Status](https://travis-ci.org/mkrogemann/try-until.png)](https://travis-ci.org/mkrogemann/try-until)
[![Code Climate](https://codeclimate.com/github/mkrogemann/try-until.png)](https://codeclimate.com/github/mkrogemann/try-until)
[![Coverage Status](https://coveralls.io/repos/mkrogemann/try-until/badge.png?branch=master)](https://coveralls.io/r/mkrogemann/try-until)
[![Dependency Status](https://gemnasium.com/mkrogemann/try-until.png)](https://gemnasium.com/mkrogemann/try-until)
[![Gem Version](https://badge.fury.io/rb/try-until.png)](http://badge.fury.io/rb/try-until)

Usage
=====

Below is an example that expects a JSON response (eg from a REST call) to contain an 'id' key with a certain value.

```ruby
require 'try-until'
require 'json'

include TryUntil

probe = Probe.new(Target.new, method_sym, [arg_1, arg_2, ...])

result = Repeatedly.new(probe)
  .attempts(5)
  .interval(10)
  .delay(10)
  .rescues([ ArgumentError, IOError ])
  .stop_when(lambda { |response| JSON.parse(response.body)['id'] == 'some_id' })
  .log_to($stdout)
  .execute
```

The settings above mean:
 - try up to five times
 - waiting ten seconds between tries
 - with an initial delay of ten seconds
 - rescue from ArgumentError and IOError (all others will bubble up)
 - stop when response document contains 'id' with value 'some_id'
 - log status (condition met, number of attempts left) to sdtout for each try

The example assumes that the target of the repeated call returns an HTTP response with a JSON body.

Not all of these settings are required. These are the default values:

```ruby
attempts   = 3
interval   = 0
delay      = 0
rescues    = []
stop_when  = lambda { |response| false }
log_to     = TryUntil::NullPrinter.new
```

The implementation of the 'Target' class is not shown here. It can be any Ruby class in your system. An instance of this class serves as the 'target' that you want to repeatedly call.

WARNING: Any lambda you create for the 'stop_when' field MUST expect one parameter as shown above ('response' in this example). If you forget this, you will run into the dreaded 'wrong number of arguments (1 for 0)' problem.

Supported Rubies
================

The gem has been developed in MRI 1.9.3 and is being continuously tested in MRI 1.9.3, 2.0.0, 2.1.0 and in jruby-head (1.9-mode).

What's next?
============

Pull requests, issue reports and feedback in general are appreciated.

Please let me know what's missing / what would make sense for you
