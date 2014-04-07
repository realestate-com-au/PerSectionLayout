PerSectionLayout
================

[![Build Status](https://travis-ci.org/sync/PerSectionLayout.svg?branch=master)](https://travis-ci.org/sync/PerSectionLayout)

Custom collection view layout, inspired by PSTCollectionView and RTFlowLayout (https://github.com/radianttap/RTFlowLayout)

Setup
-----

PerSectionLayout uses *cocoapods* to manage the iOS dependencies and *xcpretty* to make the output of the command line *xcodebuild* readable. There is a *Gemfile* with the ruby dependencies for bundler to use.

* `cd PerSectionLayout`
* `bundle install`
* `make test`

The *cocoapods* directory is checked into source control, so you only have to worry about pods if you need to change any of the dependencies, in which case:

* edit the *Podfile* to add/remove/update your dependencies
* run `pod install`
* `open PerSectionLayout.xcworkspace` and check the project still works
* `make test` to check the build still passes
* add the updated *Podfile* and *Pods* directory to git
