$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName            = 'nextcloud-talk'
  
  fileType               = 'msi'
 
  url64                  = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/v1.1.9/Nextcloud.Talk-windows-x64.msi'
  checksum64             = '9395100f61705fc7ee58b56dc5dcbd8e32ff50f0ac96e02b123f0d6ee12edf6f'
  checksumType64         = 'sha256'
  silentArgs             = '/quiet /norestart INSTALLLEVEL=1'
  validExitCodes         = @(0)
  softwareName           = 'nextcloud-talk'
}
Install-ChocolateyPackage @packageArgs
