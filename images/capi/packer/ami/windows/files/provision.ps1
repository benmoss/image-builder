mkdir -force C:\k
[Environment]::SetEnvironmentVariable("Path", $env:Path+";C:\k", [System.EnvironmentVariableTarget]::Machine)

curl.exe -Lo cloudbase-init.zip https://storage.googleapis.com/pks-windows-misc/cloudbase-init.zip
tar -xf .\cloudbase-init.zip
Start-Process -Wait -PassThru -FilePath "msiexec.exe" -ArgumentList "/i C:\Users\Administrator\CloudbaseInitSetup.msi /qn /L*v C:\log.txt"
