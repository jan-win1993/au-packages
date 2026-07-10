$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'nextcloud-talk'
  
  fileType               = 'msi'
 
  url64                  = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/v2.2.1/Nextcloud.Talk-windows-x64.msi'
  checksum64             = 'fd8de41a43b11a4bb48c77ba42e907ee135a5e37eaabb430d179ab6698bc7d67'
  checksumType64         = 'sha256'
  silentArgs             = '/quiet /norestart INSTALLLEVEL=1'
  validExitCodes         = @(0)
  softwareName           = 'nextcloud-talk'
}
Install-ChocolateyPackage @packageArgs
