# Docker Windows IIS Python WindowsAuthentication and Authorization
Project for Docker Windows Container with IIS, Python Flask, Windows Authentication and Windows Authorization.

## Props to:
- https://gist.github.com/bparaj/ac8dd5c35a15a7633a268e668f4d2c94 (bparaj/howto_python_flask_iis_wfastcgi)
- https://gist.github.com/cmydur/6d4943bdab4fca7ae46ed8fc31aec7b3 (cmydur/IIS Configuration.ps1) 
- https://serverfault.com/a/812378 (https://serverfault.com/questions/807181/create-fastcgi-application-with-powershell) (Seth and hraphrap)
- https://medium.com/@dpralay07/deploy-a-python-flask-application-in-iis-server-and-run-on-machine-ip-address-ddb81df8edf3 
- https://medium.com/@nerdijoe/how-to-deploy-flask-on-iis-with-windows-authentication-733839d657b7 
- https://stackoverflow.com/a/647798 (https://stackoverflow.com/questions/647515/how-can-i-find-where-python-is-installed-on-windows) (elo80ka and Mrityunjai)

## Knowledge to lookup: 
- The above links in "Props to" and the following: 
- https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts 
- https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/gmsa-configure-app 
- https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/gmsa-run-container 
- https://docs.microsoft.com/en-us/iis/configuration/system.webserver/handlers/add 
- https://hub.docker.com/_/python?tab=tags

## Getting started
Hi, this repo can do exactly what is promised in the title.

In order to use the Dockerfile, you need to set up a [gMSA](https://docs.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/getting-started-with-group-managed-service-accounts). account. (Mentioned in the Knowledge to lookup)

```dockerfile
  docker build --progress=plain -t imagename .
  docker run --security-opt "credentialspec=file://contoso_webapp01.json" --hostname webapp01 -it -p 8000:5000 imagename powershell
```

