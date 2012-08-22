#!/bin/bash

# Purpose: Starting nano watch on pi's machine
# Author : Anh K. Huynh
# Date   : 2012 July 5th

export rvm_path="/home/pi/.rvm"
export LANG="en_US.UTF-8"
source "/home/pi/.rvm/scripts/rvm"
rvm use default

case $1 in
  "watch"|"view")
    action="$*" ;;
  *)
    echo >&2 ":: You must specify an action (view, watch)"; exit 1 ;;
esac

exec "/home/pi/.rvm/gems/ruby-1.9.3-p194/bin/nanoc" $action
