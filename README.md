try-until
=========

[![Build Status](https://travis-ci.org/mkrogemann/try-until.png)](https://travis-ci.org/mkrogemann/try-until)
[![Code Climate](https://codeclimate.com/github/mkrogemann/try-until.png)](https://codeclimate.com/github/mkrogemann/try-until)
[![Dependency Status](https://gemnasium.com/mkrogemann/try-until.png)](https://gemnasium.com/mkrogemann/try-until)
[![Gem Version](https://badge.fury.io/rb/try-until.png)](http://badge.fury.io/rb/try-until)

Usage
=====

Below is an example that expects a JSON response (eg from a REST call) to contain an 'id' key with a certain value.

```ruby
require 'try-until'

include TryUntil

result = Repeatedly.new(Probe.new(Target.new, method_sym, [arg_1, arg_2, ...]))
  .attempts(5)
  .interval(10)
  .rescues([ ArgumentError, IOError ])
  .stop_when(lambda { |response| JSON.parse(response.body)['id'] == 'some_id' })
.execute
```

Not all of the above settings are required. These are the default values:

```ruby
attempts   = 3
interval   = 0
rescues    = []
stop_when  = lambda { false }
```

Supported Rubies
================

The gem has been developed in MRI 1.9.3 and is being continuously tested in MRI 1.9.3 and 2.0.0 plus jruby-head in 1.9-mode and rbx-head in 1.9-mode.

What's next?
============

Please let me know what's missing/what would make sense for you