$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.2.2.1455_signed_x86.msi'
  checksum        = '16ddae747917395ec45a3578ab38eee9d69a72827cd35b04dcd8e15f75ef2446'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.2.2.1455_signed.msi'
  checksum64      = '6d34dcc39b09e2059d773dad0092b0cace80726e887fe1905e4a5cb92c521012'
  checksumType64  = 'sha256'
  silentArgs      = "/qn"
  validExitCodes  = @(0, 3010, 1641)
}
Start-Process "AutoHotKey" -Verb runas -ArgumentList "`"$toolsDir\chocolateyinstall.ahk`""
# Start installation process
Install-ChocolateyPackage @packageArgs
