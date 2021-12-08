$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName     = 'openvpn-connect'
  fileType        = 'MSI'
  softwareName    = 'OpenVPN-Connect'
  url             = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.3.3.2562_signed_x86.msi'
  checksum        = 'bb8447a4776a5ddee887250274b9e0dec730a5ef1dcef6b284c18829e02ddf7e'
  checksumType    = 'sha256'
  url64bit        = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.3.3.2562_signed.msi'
  checksum64      = 'bb8447a4776a5ddee887250274b9e0dec730a5ef1dcef6b284c18829e02ddf7e'
  checksumType64  = 'sha256'
  silentArgs      = "/qn"
  validExitCodes  = @(0, 3010, 1641)
}

Get-ChocolateyWebFile -packageName $packageArgs['packageName'] `
-fileFullPath "${toolsDir}\openvpn-connect.msi" `
-Url $packageArgs['url64bit'] `
-checksum $packageArgs['checksum64'] `
-checksumType $packageArgs['checksumType64'] 
$msiFile = Join-Path $toolsDir 'openvpn-connect.msi'
$outputFile = Join-Path $toolsDir 'openvpn-cert.cer'
$exportType =[System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
$cert = (Get-AuthenticodeSignature $msiFile).SignerCertificate
[System.IO.File]::WriteAllBytes($outputFile, $cert.Export($exportType))
certutil -addstore -f "TrustedPublisher" $toolsdir\openvpn-cert.cer

# Start installation process
Install-ChocolateyPackage @packageArgs
