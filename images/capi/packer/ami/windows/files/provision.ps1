Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install kubelet --global
scoop install kubeadm --global
scoop install kubectl --global

mkdir -force "C:\ProgramData\wins"
$env:Path += ";C:\ProgramData\wins"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)

curl.exe -Lo "C:\ProgramData\wins\wins.exe" https://github.com/rancher/wins/releases/download/v0.0.4/wins.exe

wins srv app run --register
Start-Service rancher-wins

mkdir -force /var/log/kubelet
mkdir -force /var/lib/kubelet/etc/kubernetes
mkdir -force /etc/kubernetes/pki
New-Item -path C:\var\lib\kubelet\etc\kubernetes\pki -type SymbolicLink -value C:\etc\kubernetes\pki\

$kubeletBinPath=$(where.exe kubelet)
New-Service -Name "kubelet" -StartupType Automatic -DependsOn "docker" -BinaryPathName "$kubeletBinPath --windows-service --cert-dir=$env:SYSTEMDRIVE\var\lib\kubelet\pki --config=/var/lib/kubelet/config.yaml --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --pod-infra-container-image=`"mcr.microsoft.com/k8s/core/pause:1.2.0`" --enable-debugging-handlers  --cgroups-per-qos=false --enforce-node-allocatable=`"`" --network-plugin=cni --resolv-conf=`"`" --log-dir=/var/log/kubelet --logtostderr=false --image-pull-progress-deadline=20m --cloud-provider=aws --feature-gates CSIMigration=false"

curl.exe -Lo cloudbase-init.zip https://storage.googleapis.com/pks-windows-misc/cloudbase-init.zip
tar -xf .\cloudbase-init.zip
Start-Process -Wait -PassThru -FilePath "msiexec.exe" -ArgumentList "/i C:\Users\Administrator\CloudbaseInitSetup.msi /qn /L*v C:\log.txt"

New-NetFirewallRule -Name kubelet -DisplayName 'kubelet' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 10250
