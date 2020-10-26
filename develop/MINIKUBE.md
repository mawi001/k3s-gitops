# Develop

Minikube can be used for development and testing.

It also runs on ARM now :] These docs might help setting up your dev env.

https://github.com/kubernetes/minikube/issues/6843#issuecomment-596064661

Download

```sh
curl https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm -O && \
chmod +x minikube-linux-arm && mv minikube-linux-arm /usr/local/bin
```

## No drivers for arm

There are no supported drivers on arm, except for `none` which requires `root`

```sh
pi@raspberrypi:~ $ ./minikube-linux-arm start
😄  minikube v1.14.1 on Raspbian 10.4 (arm)
👎  Unable to pick a default driver. Here is what was considered, in preference order:
    ▪ docker: Not installed: docker driver is not supported on "arm" systems yet
    ▪ kvm2: Not installed: exec: "virsh": executable file not found in $PATH
    ▪ none: Not healthy: the 'none' driver must be run as the root user
    ▪ podman: Not installed: podman driver is not supported on "arm" systems yet
    ▪ virtualbox: Not installed: unable to find VBoxManage in $PATH
    ▪ vmware: Not installed: exec: "docker-machine-driver-vmware": executable file not found in $PATH

❌  Exiting due to DRV_NOT_DETECTED: No possible driver was detected. Try specifying --driver, or see https://minikube.sigs.k8s.io/docs/start/
```

## No docker

```sh
pi@raspberrypi:~ $ ./minikube-linux-arm start --driver docker
😄  minikube v1.14.1 on Raspbian 10.4 (arm)
✨  Using the docker driver based on user configuration

🤷  Exiting due to PROVIDER_DOCKER_NOT_FOUND: The 'docker' provider was not found: docker driver is not supported on "arm" systems yet
💡  Suggestion: Try other drivers
📘  Documentation: https://minikube.sigs.k8s.io/docs/drivers/docker/
```


Switch to `root` and try with `none` will tell package `conntrack` is missing on `rasbian-lite`

```sh
pi@raspberrypi:~ $ sudo -i

root@raspberrypi:~# minikube-linux-arm start --driver none
😄  minikube v1.14.1 on Raspbian 10.4 (arm)
✨  Using the none driver based on user configuration

❌  Exiting due to GUEST_MISSING_CONNTRACK: Sorry, Kubernetes 1.19.2 requires conntrack to be installed in root's path

```

## Install missing package `conntrack`

```sh
root@raspberrypi:~# apt-get install conntrack
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Suggested packages:
  nftables
The following NEW packages will be installed:
  conntrack
0 upgraded, 1 newly installed, 0 to remove and 29 not upgraded.
Need to get 28.5 kB of archives.
After this operation, 79.9 kB of additional disk space will be used.
Get:1 http://mirror.serverius.net/raspbian/raspbian buster/main armhf conntrack armhf 1:1.4.5-2 [28.5 kB]
Fetched 28.5 kB in 0s (91.2 kB/s)
apt-listchanges: Can't set locale; make sure $LC_* and $LANG are correct!
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_TIME = "nl_NL.UTF-8",
	LC_MONETARY = "nl_NL.UTF-8",
	LC_ADDRESS = "nl_NL.UTF-8",
	LC_TELEPHONE = "nl_NL.UTF-8",
	LC_NAME = "nl_NL.UTF-8",
	LC_MEASUREMENT = "nl_NL.UTF-8",
	LC_IDENTIFICATION = "nl_NL.UTF-8",
	LC_NUMERIC = "nl_NL.UTF-8",
	LC_PAPER = "nl_NL.UTF-8",
	LANG = "en_GB.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to a fallback locale ("en_GB.UTF-8").
locale: Cannot set LC_ALL to default locale: No such file or directory
Selecting previously unselected package conntrack.
(Reading database ... 42885 files and directories currently installed.)
Preparing to unpack .../conntrack_1%3a1.4.5-2_armhf.deb ...
Unpacking conntrack (1:1.4.5-2) ...
Setting up conntrack (1:1.4.5-2) ...
Processing triggers for man-db (2.8.5-2) ...
````

## minikube also requires cgroup enabled


```sh
root@raspberrypi:~# minikube-linux-arm start --driver none
😄  minikube v1.14.1 on Raspbian 10.4 (arm)
✨  Using the none driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🤹  Running on localhost (CPUs=4, Memory=3827MB, Disk=59832MB) ...
ℹ️  OS release is Raspbian GNU/Linux 10 (buster)
🐳  Preparing Kubernetes v1.19.2 on Docker 19.03.13 ...
    > kubelet.sha256: 65 B / 65 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm.sha256: 65 B / 65 B [--------------------------] 100.00% ? p/s 0s
    > kubectl.sha256: 65 B / 65 B [--------------------------] 100.00% ? p/s 0s
    > kubectl: 34.31 MiB / 34.31 MiB [----------------] 100.00% 4.27 MiB p/s 8s
    > kubeadm: 30.62 MiB / 30.62 MiB [---------------] 100.00% 2.13 MiB p/s 14s
    > kubelet: 84.53 MiB / 84.53 MiB [---------------] 100.00% 4.45 MiB p/s 19s
💢  initialization failed, will try again: run: /bin/bash -c "sudo env PATH=/var/lib/minikube/binaries/v1.19.2:$PATH kubeadm init --config /var/tmp/minikube/kubeadm.yaml  --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests,DirAvailable--var-lib-minikube,DirAvailable--var-lib-minikube-etcd,FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml,FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml,FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml,FileAvailable--etc-kubernetes-manifests-etcd.yaml,Port-10250,Swap": exit status 1
stdout:
[init] Using Kubernetes version: v1.19.2
[preflight] Running pre-flight checks
[preflight] The system verification failed. Printing the output from the verification:
KERNEL_VERSION: 5.4.51-v7l+
CONFIG_NAMESPACES: enabled
CONFIG_NET_NS: enabled
CONFIG_PID_NS: enabled
CONFIG_IPC_NS: enabled
CONFIG_UTS_NS: enabled
CONFIG_CGROUPS: enabled
CONFIG_CGROUP_CPUACCT: enabled
CONFIG_CGROUP_DEVICE: enabled
CONFIG_CGROUP_FREEZER: enabled
CONFIG_CGROUP_SCHED: enabled
CONFIG_CPUSETS: enabled
CONFIG_MEMCG: enabled
CONFIG_INET: enabled
CONFIG_EXT4_FS: enabled
CONFIG_PROC_FS: enabled
CONFIG_NETFILTER_XT_TARGET_REDIRECT: enabled (as module)
CONFIG_NETFILTER_XT_MATCH_COMMENT: enabled (as module)
CONFIG_OVERLAY_FS: enabled (as module)
CONFIG_AUFS_FS: not set - Required for aufs.
CONFIG_BLK_DEV_DM: enabled (as module)
DOCKER_VERSION: 19.03.13
DOCKER_GRAPH_DRIVER: overlay2
OS: Linux
CGROUPS_CPU: enabled
CGROUPS_CPUACCT: enabled
CGROUPS_CPUSET: enabled
CGROUPS_DEVICES: enabled
CGROUPS_FREEZER: enabled
CGROUPS_MEMORY: missing
CGROUPS_HUGETLB: missing
CGROUPS_PIDS: enabled

stderr:
W1025 23:47:00.075286    8076 configset.go:348] WARNING: kubeadm cannot validate component configs for API groups [kubelet.config.k8s.io kubeproxy.config.k8s.io]
	[WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
	[WARNING Swap]: running with swap on is not supported. Please disable swap
	[WARNING FileExisting-socat]: socat not found in system path
	[WARNING SystemVerification]: missing optional cgroups: hugetlb
	[WARNING Service-Kubelet]: kubelet service is not enabled, please run 'systemctl enable kubelet.service'
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR SystemVerification]: missing required cgroups: memory
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher
```


Update `/boot/cmdline.txt` and append  `cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory`

Complete `cmdline.txt`

```
root@raspberrypi:~# cat /boot/cmdline.txt
console=serial0,115200 console=tty1 root=PARTUUID=61abc825-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```

Reboot

```sh
root@raspberrypi:~# reboot
```


## Retry

```sh
pi@raspberrypi:~ $ sudo -i

SSH is enabled and the default password for the 'pi' user has not been changed.
This is a security risk - please login as the 'pi' user and type 'passwd' to set a new password.

root@raspberrypi:~#
root@raspberrypi:~#
root@raspberrypi:~# minikube-linux-arm start --driver none
😄  minikube v1.14.1 on Raspbian 10.4 (arm)
✨  Using the none driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
🔄  Restarting existing none bare metal machine for "minikube" ...
ℹ️  OS release is Raspbian GNU/Linux 10 (buster)
🐳  Preparing Kubernetes v1.19.2 on Docker 19.03.13 ...
🤹  Configuring local host environment ...

❗  The 'none' driver is designed for experts who need to integrate with an existing VM
💡  Most users should use the newer 'docker' driver instead, which does not require root!
📘  For more information, see: https://minikube.sigs.k8s.io/docs/reference/drivers/none/

❗  kubectl and minikube configuration will be stored in /root
❗  To use kubectl or minikube commands as your own user, you may need to relocate them. For example, to overwrite your own settings, run:

    ▪ sudo mv /root/.kube /root/.minikube $HOME
    ▪ sudo chown -R $USER $HOME/.kube $HOME/.minikube

💡  This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
🔎  Verifying Kubernetes components...
🌟  Enabled addons: default-storageclass, storage-provisioner
💡  kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" by default
```

## w00t


```sh
root@raspberrypi:~# minikube-linux-arm kubectl -- get all -A  
NAMESPACE     NAME                                      READY   STATUS             RESTARTS   AGE
kube-system   pod/coredns-f9fd979d6-4pttc               1/1     Running            0          3m2s
kube-system   pod/etcd-raspberrypi                      1/1     Running            0          3m
kube-system   pod/kube-apiserver-raspberrypi            1/1     Running            0          3m
kube-system   pod/kube-controller-manager-raspberrypi   1/1     Running            0          3m
kube-system   pod/kube-proxy-grwvp                      1/1     Running            0          3m2s
kube-system   pod/kube-scheduler-raspberrypi            1/1     Running            0          3m
kube-system   pod/storage-provisioner                   0/1     CrashLoopBackOff   4          3m2s

NAMESPACE     NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  3m11s
kube-system   service/kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   3m8s

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/kube-proxy   1         1         1       1            1           kubernetes.io/os=linux   3m8s

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/coredns   1/1     1            1           3m8s

NAMESPACE     NAME                                DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/coredns-f9fd979d6   1         1         1       3m2s
```

## Test Pod

```sh
root@raspberrypi:~# minikube-linux-arm kubectl -- run nginx --image=nginx

root@raspberrypi:~# minikube-linux-arm kubectl -- get po  --show-labels -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP           NODE          NOMINATED NODE   READINESS GATES   LABELS
nginx   1/1     Running   0          72s   172.17.0.3   raspberrypi   <none>           <none>            run=nginx

```
