$siteName = "FlaskApp"
$sitePath = "C:\inetpub\wwwroot\$siteName" 

Write-Host "Hi, you entered the Set-InitialServerState.ps1"

Write-Host "I am going to install the required WindowsFeatures (IIS and so on)"

$windowsServerFeatures = @(
    "NET-Framework-45-ASPNET",
    "Web-App-Dev",
    "Web-CGI",
    "Web-Common-Http",
    "Web-Default-Doc",
    "Web-Dir-Browsing",
    "Web-Filtering",
    "Web-Health",
    "Web-Http-Errors",
    "Web-Http-Logging",
    "Web-Mgmt-Console",
    "Web-Mgmt-Service",
    "Web-Mgmt-Tools",
    "Web-Performance",
    "Web-Security",
    "Web-Server",
    "Web-Stat-Compression",
    "Web-Static-Content",
    "Web-WebServer",
    "Web-Windows-Auth",
    "Web-Asp-Net45",
    "Web-Net-Ext45",
    "Web-ISAPI-Ext",
    "Web-ISAPI-Filter",
    "Web-Url-Auth"
)

Install-WindowsFeature $windowsServerFeatures -Verbose

Write-Host "Alright, now I am going to add a new website to the IIS"

New-Item -ItemType "directory" -Path $sitePath

Copy-Item "app.py" -Destination $sitePath

New-WebSite -Name $siteName -Port 5000 -PhysicalPath $sitePath

#Enable windowsAuthentication and disable anonymousAuthentication
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/anonymousAuthentication -name enabled -value false -PSPath IIS:\ -location $siteName
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath IIS:\ -location $siteName