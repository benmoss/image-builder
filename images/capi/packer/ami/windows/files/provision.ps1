Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install kubelet
scoop install kubeadm
scoop install kubectl

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

New-Service -Name "kubelet" -StartupType Automatic -DependsOn "docker" -BinaryPathName "$kubeletBinPath --windows-service --cert-dir=$env:SYSTEMDRIVE\var\lib\kubelet\pki --config=/var/lib/kubelet/config.yaml --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --hostname-override=$(hostname) --pod-infra-container-image=`"mcr.microsoft.com/k8s/core/pause:1.2.0`" --enable-debugging-handlers  --cgroups-per-qos=false --enforce-node-allocatable=`"`" --network-plugin=cni --resolv-conf=`"`" --log-dir=/var/log/kubelet --logtostderr=false --image-pull-progress-deadline=20m"

curl.exe -Lo cloudbase-init.zip https://github.com/gab-satchi/cloudbase-init-installer-1/suites/353871458/artifacts/654819
tar -xf .\cloudbase-init.zip --strip=1
Start-Process -Wait -PassThru -FilePath "msiexec.exe" -ArgumentList "/i C:\Users\Administrator\CloudbaseInitSetup.msi /qn /L*v C:\log.txt"

curl.exe -LO https://downloadmirror.intel.com/28396/eng/PROWinx64.exe
mkdir $env:TMP\driver
tar -xf .\PROWinx64.exe -C $env:TMP\driver
& $env:TMP\driver\APPS\PROSETDX\Winx64\DxSetup.exe /qn
