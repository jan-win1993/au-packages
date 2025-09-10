$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'nextcloud-talk'
  
  fileType               = 'msi'
 
  url64                  = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/v1.2.6/Nextcloud.Talk-windows-x64.msi'
  checksum64             = '1172f89f0f0ad19c97d881e94e6540e039c70f758f81c4b163cfc04091c34e73'
  checksumType64         = 'sha256'
  silentArgs             = '/quiet /norestart INSTALLLEVEL=1'
  validExitCodes         = @(0)
  softwareName           = 'nextcloud-talk'
}
Install-ChocolateyPackage @packageArgs
