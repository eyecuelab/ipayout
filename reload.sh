#!/bin/bash

rm ipayout-0.0.1.gem
gem build ipayout.gemspec
gem install --local ipayout-0.0.1.gem