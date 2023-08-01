#!/bin/bash
set -eo pipefail

if [ "$EUID" -ne 0 ]; then
  exec sudo etebase-server "$@"
fi

cd /opt/etebase
. .venv/bin/activate
exec uvicorn etebase_server.asgi:application --host 127.0.0.1 --port 3735
