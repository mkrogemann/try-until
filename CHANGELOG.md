Changelog
=========

Version 0.4.4 - released 2013-12-26
-------------

* Add MRI 2.1.0 to supported versions and .travis.yml
* No longer support Rubinius and remove rbx from .travis.yml


Version 0.4.3 - released 2013-12-07
-------------

* Adjust to the changes made in Rubinius/RVM/Travis
* Update dependencies


Version 0.4.2 - released 2013-09-27
-------------

* Bugfix: Repeatedly#execute would sleep one more time than it should


Version 0.4.1 - released 2013-09-24
-------------

* Bugfix: Repeatedly would sleep at least once even if condition was met after first sample


Version 0.4.0 - released 2013-09-22
-------------

* Add rudimentary logging feature. Printing internal state of Repeatedly to given IO object
* Add delay feature: Do not start sampling the probe until given delay has elapsed
* Bugfix: A single argument given as key value pairs was not preserved as a Hash on arrival at the target object


Version 0.3.0 - released 2013-09-10
-------------

* Redesign: Removing meta-programming altogether, use plain objects and #new instead


Version 0.2.0 - released 2013-09-09
-------------

* Sensible feature: Re-raise a caught error as soon as we run out of attempts (tries)


Version 0.1.0 - released 2013-09-07
-------------

* First release
