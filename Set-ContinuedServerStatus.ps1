$siteName = "FlaskApp"
$sitePath = "C:\inetpub\wwwroot\$siteName"

#Get Python dir
$pythonDir = & python -c "import os, sys; print(os.path.dirname(sys.executable))"

#Copy wfastcgi.py to the Website folder
Copy-Item "$pythonDir\Lib\site-packages\wfastcgi.py" -Destination $sitePath

#Paths with quotes
$fullPythonEXEPathWithQuots = "`"$pythonDir\python.exe`""
$pythonWfastcgiArgumentWithQuots = "`"$sitePath\wfastcgi.py`""

#Paths
$fullPythonEXEPath = "$pythonDir\python.exe"
$pythonWfastcgiArgument = "$sitePath\wfastcgi.py"

#Path to FastCGI application enabled by "wfastcgi-enable"
$configPathRoot = "system.webServer/fastCgi/application[@fullPath=$fullPythonEXEPathwithQuots]"
#Get-WebConfiguration $configPath

#Get FastCGI application enabled by "wfastcgi-enable" and change the path and argument path
Set-WebConfiguration $configPathRoot -Value @{ 'fullPath' = $fullPythonEXEPath; 'arguments' = $pythonWfastcgiArgumentWithQuots }


#Add environmentVariables to FastCGI application
Add-WebConfiguration "system.webServer/fastCgi/application[@fullPath=$fullPythonEXEPathwithQuots]/environmentVariables" -Value @{'Name' = 'PYTHONPATH'; Value = "$sitePath" }, @{'Name' = 'WSGI_HANDLER'; Value = 'app.app' }
#Get-WebConfiguration "system.webServer/fastCgi/application[@fullPath=$fullPythonEXEPathwithQuots]/environmentVariables/environmentVariable"

Copy-Item "web.config" -Destination $sitePath

#Change the handler path in web.config in order to match FastCGI application
$webConfigXMLPath = "$sitePath\web.config"
$webConfigXML = [xml](Get-Content $webConfigXMLPath)
#Powershell is automatically escaping the quotes to (&quot;) at "$webConfigXML.Save($webConfigXMLPath)"
$webConfigXML.configuration.'system.webServer'.handlers.add.scriptProcessor = "$fullPythonEXEPath|`"$pythonWfastcgiArgument`""
$webConfigXML.Save($webConfigXMLPath)

Start-Sleep -s 1

Stop-WebSite $siteName
Start-Sleep -s 1
Start-WebSite $siteName