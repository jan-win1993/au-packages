$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.4.4.3412_signed_x86.msi'
  checksum        = 'fb4efcca3894b13aa7e786e08206c0e1e26c25c538dce9db49e9e609d7d5db1a'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.4.4.3412_signed.msi'
  checksum64      = '3372a2872bf5609b2fd6eca832090aeb91aa1507276f39839789d7851a657636'
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
