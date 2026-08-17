#!/bin/bash
#$1 libetebase version
set -eo pipefail

PYENV_ROOT=$PWD/tool/integration/cache/python
SERVER_DIR=$PWD/tool/integration/cache/server
STATIC_DIR="$RUNNER_TEMP/etebase-static"
MEDIA_DIR="$RUNNER_TEMP/etebase-media"

function startServer {
  echo "::group::Start etesync server"
  ./manage.py migrate
  nohup uvicorn etebase_server.asgi:application --host 127.0.0.1 --port 3735 &
  echo ::endgroup::
}

# install js client
echo "::group::Restoring js_client"
npm --prefix tool/js_client install
echo ::endgroup::

# re-initialize server if restored from cache
mkdir -p "$STATIC_DIR" "$MEDIA_DIR"
if [ "$CACHE_HIT" = "true" ]; then
  # reactivate venv and start server
  cd "$SERVER_DIR"
  source .venv/bin/activate
  startServer
  exit 0
fi

# enable python 3.12
echo "::group::Setup python 3.12"
brew install pyenv || true
export PYENV_ROOT
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 3.12
pyenv global 3.12

which python3
python3 --version
echo ::endgroup::

echo "::group::Build etebase server"
# clone etebase server
mkdir -p "$(dirname "$SERVER_DIR")"
git clone https://github.com/etesync/server.git "$SERVER_DIR"
cd "$SERVER_DIR"
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
