#!/bin/bash

set -e
whole_cmd="$(ps -o args= $PPID)"
eval arr_cmd=($whole_cmd)
caller_path=${arr_cmd[0]}

if [[ $caller_path == *"gnueabihf"* ]]; then
  exec "/usr/bin/arm-linux-gnueabihf-ld" "$@"
else
  exec "/usr/bin/ld.real" "$@"
fi
