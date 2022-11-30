$rustupInitPath = "$env:RUNNER_TEMP\rustup-init.exe"

# setup rust
$client = new-object System.Net.WebClient
$client.DownloadFile("https://static.rust-lang.org/rustup/dist/i686-pc-windows-gnu/rustup-init.exe", $rustupInitPath)
& $rustupInitPath -y

# build libetebase
$libetebaseDir = "$env:RUNNER_TEMP\libetebase"
& git clone https://github.com/etesync/libetebase.git -b v0.5.3 $libetebaseDir
cd $libetebaseDir
& make
& make install
