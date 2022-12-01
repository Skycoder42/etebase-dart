$rustupInitPath = "$env:RUNNER_TEMP\rustup-init.exe"

# build libetebase
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
& git clone https://github.com/etesync/libetebase.git -b v0.5.3 $libetebaseDir
cd $libetebaseDir
& make
Copy-Item .\target\release\etebase.dll -Destination "$env:GITHUB_WORKSPACE\packages\etebase\tool\integration"

# build etebase server
$etebaseServerDir = "$env:RUNNER_TEMP\etebase-server"
& git clone https://github.com/etesync/server.git $etebaseServerDir
cd $etebaseServerDir
& python3 -m venv .venv
.venv\Scripts\Activate.ps1
& pip install -r requirements.txt

& sed -e '/ETEBASE_CREATE_USER_FUNC/s/^#*/#/g' -i "${BASE_DIR}/etebase_server/settings.py"
Copy-Item .\etebase-server.ini.example -Destination .\etebase-server.ini
& python3 ./manage.py migrate
& python3 ./manage.py createsuperuser
