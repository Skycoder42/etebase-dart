#!/bin/bash
set -ex

cd tool/integration/libetebase/server
source .venv/bin/activate
exec uvicorn etebase_server.asgi:application "$@"
