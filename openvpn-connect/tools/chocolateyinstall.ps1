$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.2.3.1851_signed_x86.msi'
  checksum        = 'bfd176271cca8c1e7fae446621a985388bf55d023668af8e5dcec9ec4560dd85'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.2.3.1851_signed.msi'
  checksum64      = '58973ceba1dfb77ac98977f264b5aebe4ca094c17ada72c4d2767d2a2c7607c5'
  checksumType64  = 'sha256'
  silentArgs      = "/qn"
  validExitCodes  = @(0, 3010, 1641)
}

Start-Process "AutoHotKey" -Verb runas -ArgumentList "`"$toolsDir\chocolateyinstall.ahk`""
# Start installation process
Install-ChocolateyPackage @packageArgs