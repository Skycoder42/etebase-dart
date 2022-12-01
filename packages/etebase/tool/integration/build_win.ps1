$rustupInitPath = "$env:RUNNER_TEMP\rustup-init.exe"

# build libetebase
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
& git clone https://github.com/etesync/libetebase.git -b v0.5.3 $libetebaseDir
cd $libetebaseDir
& make
Copy-Item .\target\release\etebase.dll -Destination "$env:GITHUB_WORKSPACE\packages\etebase\tool\integration"

# create docker image
$etebaseDockerDir = "$env:RUNNER_TEMP\docker-etebase"
& git clone https://github.com/victor-rds/docker-etebase.git $etebaseDockerDir
cd $etebaseDockerDir
docker build -f tags/base/Dockerfile -t victorrds/etesync .
