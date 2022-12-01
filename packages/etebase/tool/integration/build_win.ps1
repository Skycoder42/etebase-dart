$rustupInitPath = "$env:RUNNER_TEMP\rustup-init.exe"

# build libetebase
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
& git clone https://github.com/etesync/libetebase.git -b v0.5.3 $libetebaseDir
cd $libetebaseDir
& make
dir .\target\release
