#!/bin/bash
#$1 libetebase version
set -e

STATIC_DIR="$RUNNER_TEMP/etebase-static"
MEDIA_DIR="$RUNNER_TEMP/etebase-media"

TAG=${1:-master}
PATCH_FILE=$PWD/tool/integration/libetebase-macos.patch
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

function startServer {
  echo ::group::Start etesync server
  ./manage.py migrate
  nohup uvicorn etebase_server.asgi:application --host 127.0.0.1 --port 3735 &
  echo ::endgroup::
}

# re-initialize server if restored from cache
mkdir -p "$STATIC_DIR" "$MEDIA_DIR"
if [ "$CACHE_HIT" = "true" ]; then
  # reactivate venv and start server
  cd "$DESTDIR/$PREFIX/server"
  source .venv/bin/activate
  startServer
  exit 0
fi

# build and install libetebase
echo ::group::Build libetebase
libetebaseDir=$RUNNER_TEMP/libetebase
git clone https://github.com/etesync/libetebase.git -b "$TAG" "$libetebaseDir"
cd "$libetebaseDir"

if [ -n "$PATCH_FILE" ]; then
  git apply "$PATCH_FILE"
fi

rm Cargo.lock # delete lockfile to get up-to-date dependencies
make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"
echo ::endgroup::

# enable python 3.7
echo ::group::Setup python 3.7
PYTHON_DIRS=("$RUNNER_TOOL_CACHE"/Python/3.7.*/x64/bin)
export PATH=${PYTHON_DIRS[0]}:$PATH
which python3
echo ::endgroup::

echo ::group::Build etebase server
# clone etebase server
etebaseServerDir=$DESTDIR/$PREFIX/server
git clone https://github.com/etesync/server.git "$etebaseServerDir"
cd "$etebaseServerDir"
rm -rf .git

# build and setup etebase server
python3 -m venv --copies .venv
source .venv/bin/activate
pip3 install -r requirements.txt

cp -a  "etebase-server.ini.example" "etebase-server.ini"
sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i '' "etebase_server/settings.py"
sed -e "s#static_root = /path/to/static#static_root = $STATIC_DIR#g" -i '' "etebase-server.ini"
sed -e "s#media_root = /path/to/media#media_root = $MEDIA_DIR#g" -i '' "etebase-server.ini"
sed -e "s#allowed_host1 = example.com#allowed_host1 = *#g" -i '' "etebase-server.ini"
sed -e "s#name = db.sqlite3#name = $RUNNER_TEMP/database.sql#g" -i '' "etebase-server.ini"
echo ::endgroup::

# start the server
startServer
