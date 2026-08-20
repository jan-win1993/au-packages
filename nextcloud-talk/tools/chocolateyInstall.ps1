$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'nextcloud-talk'
  
  fileType               = 'msi'
 
  url64                  = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/v2.2.4/Nextcloud.Talk-windows-x64.msi'
  checksum64             = '9b186c6acabe38280ed5b6bccdae42e50c3b0883394f910a07a9cd64f65b8a61'
  checksumType64         = 'sha256'
  silentArgs             = '/quiet /norestart INSTALLLEVEL=1'
  validExitCodes         = @(0)
  softwareName           = 'nextcloud-talk'
}
Install-ChocolateyPackage @packageArgs
