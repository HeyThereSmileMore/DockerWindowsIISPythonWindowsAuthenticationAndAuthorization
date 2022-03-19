
#Props to:
#https://gist.github.com/bparaj/ac8dd5c35a15a7633a268e668f4d2c94 (bparaj/howto_python_flask_iis_wfastcgi)
#https://gist.github.com/cmydur/6d4943bdab4fca7ae46ed8fc31aec7b3 (cmydur/IIS Configuration.ps1)
#https://serverfault.com/a/812378 (https://serverfault.com/questions/807181/create-fastcgi-application-with-powershell) (Seth and hraphrap) 
#https://medium.com/@dpralay07/deploy-a-python-flask-application-in-iis-server-and-run-on-machine-ip-address-ddb81df8edf3
#https://medium.com/@nerdijoe/how-to-deploy-flask-on-iis-with-windows-authentication-733839d657b7
#https://stackoverflow.com/a/647798 (https://stackoverflow.com/questions/647515/how-can-i-find-where-python-is-installed-on-windows) (elo80ka and Mrityunjai)

#Knowledge to lookup:
#The above links in "props to" and the following:
#https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts
#https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/gmsa-configure-app
#https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/gmsa-run-container
#https://docs.microsoft.com/en-us/iis/configuration/system.webserver/handlers/add
#https://hub.docker.com/_/python?tab=tags


#You can use both ltsc2022 or 1809
#FROM python:windowsservercore-ltsc2022
FROM python:windowsservercore-1809

WORKDIR c:\\dev\\flasksite_iis

COPY . .


RUN powershell -command .\Set-InitialServerState.ps1
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN wfastcgi-enable
RUN powershell -command .\Set-ContinuedServerStatus.ps1

#Change application pool to NetworkService for gMSA (Group Managed Service Accounts)
RUN C:\Windows\System32\inetsrv\appcmd.exe set AppPool DefaultAppPool -'processModel.identityType':NetworkService

EXPOSE 5000