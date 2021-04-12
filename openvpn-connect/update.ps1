Import-Module au

$change_log_url = 'https://openvpn.net/vpn-server-resources/openvpn-connect-for-windows-change-log'
$url_part1 = 'https://swupdate.openvpn.net/downloads/connect/openvpn-connect-'
$url_part3_32 = '_signed_x86.msi'
$url_part3_64 = '_signed.msi'

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $change_log_url
    $regex_version = '3\.\d\.\d \(\d{3,4}\)'
    $versions = ([regex]$regex_version).Matches($download_page.Content)
    $most_recent_version = [String]$versions[0]
    $version = $most_recent_version.split()[0]
    $url_part2 = $most_recent_version.Replace(" ", ".").Replace("(", "").Replace(")", "")
    $url32= $url_part1 + $url_part2 + $url_part3_32
    $url64= $url_part1 + $url_part2 + $url_part3_64
    return @{  
        URL32 = $url32
        URL64 = $url64
        Version = $version
    }
}
function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}
update