$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'nextcloud-talk'
  
  fileType               = 'msi'
 
  url64                  = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/v1.2.3/Nextcloud.Talk-windows-x64.msi'
  checksum64             = 'b95224146cd3aa5c38ecffe9cd42aa7f25709d4db1f3c8958ebdfff70258b8ea'
  checksumType64         = 'sha256'
  silentArgs             = '/quiet /norestart INSTALLLEVEL=1'
  validExitCodes         = @(0)
  softwareName           = 'nextcloud-talk'
}
Install-ChocolateyPackage @packageArgs
