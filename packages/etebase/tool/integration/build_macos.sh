#!/bin/bash
set -ex

TAG=${1:-master}
PATCH_FILE=$PWD/tool/integration/libetebase-macos.patch
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD
STATIC_DIR=$RUNNER_TEMP/etebase-static
MEDIA_DIR=$RUNNER_TEMP/etebase-media

# build and install libetebase
libetebaseDir=$RUNNER_TEMP/libetebase
git clone https://github.com/etesync/libetebase.git -b "$TAG" "$libetebaseDir"
cd "$libetebaseDir"

if [ -n "$PATCH_FILE" ]; then
  git apply "$PATCH_FILE"
fi

make PREFIX=$PREFIX
make install PREFIX=$PREFIX DESTDIR="$DESTDIR"

# enable python 3.7
PYTHON_DIRS=("$RUNNER_TOOL_CACHE"/Python/3.7.*/x64/bin)
export PATH=${PYTHON_DIRS[0]}:$PATH
which python3

# clone etebase server
etebaseServerDir=$DESTDIR/$PREFIX/server
git clone https://github.com/etesync/server.git "$etebaseServerDir"
cd "$etebaseServerDir"
rm -rf .git

# build and setup etebase server
python3 -m venv --copies .venv
source .venv/bin/activate
pip3 install -r requirements.txt

mkdir -p "$STATIC_DIR" "$MEDIA_DIR"
cp -a  "etebase-server.ini.example" "etebase-server.ini"
sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i '' "etebase_server/settings.py"
sed -e "s#static_root = /path/to/static#static_root = $STATIC_DIR#g" -i '' "etebase-server.ini"
sed -e "s#media_root = /path/to/media#media_root = $MEDIA_DIR#g" -i '' "etebase-server.ini"
./manage.py migrate

