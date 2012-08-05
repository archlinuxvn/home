#!/bin/bash

# Purpose: Starting nano watch on pi's machine
# Author : Anh K. Huynh
# Date   : 2012 July 5th

export rvm_path="/home/pi/.rvm"
export LANG="en_US.UTF-8"
source "/home/pi/.rvm/scripts/rvm"
rvm use ruby-1.9.2-head
exec "/home/pi/.rvm/gems/ruby-1.9.2-head/bin/nanoc" watch
