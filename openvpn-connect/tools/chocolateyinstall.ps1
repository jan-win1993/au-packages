$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.7.3.4351_signed_x86.msi'
  checksum        = '030e70c37c0240bfcced09b9b66879eac5c30ce93e7b1567211080751daca2a3'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.7.3.4351_signed.msi'
  checksum64      = '239ea016de7bd6bbcbb06727c9b0df5929f26d566ec53c09991c32d59ebadfc8'
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
