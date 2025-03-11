import-module chocolatey-au

$url_part1 = 'https://github.com/nextcloud-releases/talk-desktop/releases/download/'
$releases = 'https://github.com/nextcloud-releases/talk-desktop/tags/'
$msi_name = 'Nextcloud.Talk-windows-x64.msi'

function global:au_BeforeUpdate() {
     $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
}

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url64\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {

  $regex_version="v\d\.\d\.\d<"
  $content=(Invoke-WebRequest -UseBasicParsing -Uri $releases).content
  $version_matches=([regex]$regex_version).Matches($content)
  $most_recent_version_temp = $version_matches[0] -replace ".$"
  $version = $most_recent_version_temp -replace "^."   
    @{
        URL64   = $url_part1 + "v${version}/" + $msi_name
        Version = $version
    }
}

update -ChecksumFor none
