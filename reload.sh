#!/bin/bash

rm eyecue_ipayout-0.0.1.gem
gem build eyecue_ipayout.gemspec
gem install --local eyecue_ipayout-0.0.1.gem