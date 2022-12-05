#!/bin/bash
set -ex

TAG=${1:-master}
PATCH_FILE=$PWD/tool/integration/libetebase-macos.patch
PREFIX=/tool/integration/libetebase
DESTDIR=$PWD

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
python3 -m venv --copies --upgrade-deps .venv
source .venv/bin/activate
pip3 install -r requirements.txt
sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i '' "$etebaseServerDir/etebase_server/settings.py"
cp -a  "$etebaseServerDir/etebase-server.ini.example" "$etebaseServerDir/etebase-server.ini"
./manage.py migrate
./manage.py createsuperuser

