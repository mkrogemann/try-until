try-until
=========

[![Build Status](https://travis-ci.org/mkrogemann/try-until.png)](https://travis-ci.org/mkrogemann/try-until)
[![Code Climate](https://codeclimate.com/github/mkrogemann/try-until.png)](https://codeclimate.com/github/mkrogemann/try-until)
[![Coverage Status](https://coveralls.io/repos/mkrogemann/try-until/badge.png?branch=master)](https://coveralls.io/r/mkrogemann/try-until)
[![Dependency Status](https://gemnasium.com/mkrogemann/try-until.png)](https://gemnasium.com/mkrogemann/try-until)
[![Gem Version](https://badge.fury.io/rb/try-until.png)](http://badge.fury.io/rb/try-until)

Usage
=====

Shown below is an example where we expect some target object to return a JSON response (eg from a REST call) and where we furthermore expect that response to contain an 'id' key with a certain value.

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
 - log status (condition met, number of attempts left) to stdout for each try

Not all of these settings are required. These are the default values:

```ruby
attempts   = 3
interval   = 0
delay      = 0
rescues    = []
stop_when  = lambda { |response| false }
log_to     = TryUntil::NullPrinter.new
```

In other words, you could simply do this, in case the default values suit your needs:

```ruby
require 'try-until'

include TryUntil

probe = Probe.new(Target.new, method_sym, [arg_1, arg_2, ...])

result = Repeatedly.new(probe).execute
```

You will most likely want to have at least a sensible value for ```stop_when``` though.

The implementation of the 'Target' class is not shown here. It can be any Ruby class in your system. An instance of this class serves as the 'target' that you want to repeatedly call.

CAUTION: Any lambda you create for the 'stop_when' field MUST expect ONE parameter as shown above (arbitrarily named 'response' in this example). It will receive the target object's response. If you forget to supply this parameter, you will run into the dreaded 'wrong number of arguments (1 for 0)' problem.

Supported Rubies
================

The gem has originally been developed in MRI 1.9.3 and is being continuously integrated on Travis CI using MRI 1.9.3, 2.0.0, 2.1.5, 2.2.0 and jruby-head (1.9-mode). Big Kudos to the the [Travis CI](https://travis-ci.org) team!

What's next?
============

Pull requests, issue reports and feedback in general are appreciated.

Please let me know what's missing / what would make sense for you
