﻿$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.3.7.2979_signed_x86.msi'
  checksum        = '2d6a428d211de3d2d4fb657ad770a7bd289d878c5d7c7ed32ca3fcba096dc433'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.3.7.2979_signed.msi'
  checksum64      = 'b2f8d18fb2fa633dcbd62c6652158dbb3aa81345e014b5c8b838b292074b46a9'
  checksumType64  = 'sha256'
  silentArgs      = "/qn"
  validExitCodes  = @(0, 3010, 1641)
}

$packageArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  silentArgs      = "/qn"
  validExitCodes  = @(0, 3010, 1641)
}

$processorBits = Get-ProcessorBits
# Download msi installers and extraxt certificate
if ($processorBits -eq '64')
{
  Get-ChocolateyWebFile -packageName $downloadArgs['packageName'] `
                        -fileFullPath "${toolsDir}\openvpn-connect.msi" `
                        -Url $downloadArgs['url64bit'] `
                        -checksum $downloadArgs['checksum64'] `
                        -checksumType $downloadArgs['checksumType64']
  $msiFile64 = Join-Path $toolsDir 'openvpn-connect.msi'
  $outputFile = Join-Path $toolsDir 'openvpn-cert.cer'
  $exportType =[System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
  $cert = (Get-AuthenticodeSignature $msiFile64).SignerCertificate
  [System.IO.File]::WriteAllBytes($outputFile, $cert.Export($exportType))
  certutil -addstore -f "TrustedPublisher" $toolsdir\openvpn-cert.cer
  $packageArgs['file64'] = $msiFile64
}
else {
  Get-ChocolateyWebFile -packageName $downloadArgs['packageName'] `
                        -fileFullPath "${toolsDir}\openvpn-connect32.msi" `
                        -Url $downloadArgs['url'] `
                        -checksum $downloadArgs['checksum'] `
                        -checksumType $downloadArgs['checksumType']
  $msiFile32 = Join-Path $toolsDir 'openvpn-connect32.msi'
  $outputFile = Join-Path $toolsDir 'openvpn-cert32.cer'
  $exportType =[System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
  $cert = (Get-AuthenticodeSignature $msiFile32).SignerCertificate
  [System.IO.File]::WriteAllBytes($outputFile, $cert.Export($exportType))
  certutil -addstore -f "TrustedPublisher" $toolsdir\openvpn-cert32.cer
  $packageArgs['file32'] = $msiFile32
}

# Start installation process
Install-ChocolateyInstallPackage @packageArgs

Remove-Item -Force -EA 0 -Path $toolsDir\*.msi
Remove-Item -Force -EA 0 -Path $toolsDir\*.cer
