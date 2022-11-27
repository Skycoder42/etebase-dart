#!/bin/sh
set -e

if [ ! -e "/usr/include/etebase/etebase.h" ]; then
  echo "ERROR: Cannot find /usr/include/etebase/etebase.h"
  exit 1
fi

set -x
dart run ffigen
dart run build_runner build --delete-conflicting-outputs --release --verbose
