####Server Setup####

##Service
systemctl set-default multi-user.target


apt update -y
apt upgrade -y
##apt repo update
#docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

##apt install
apt-get -y updatebs
apt-get install -y docker-ce docker-ce-cli containerd.io nvidia-container-toolkit nvidia-container-runtime nvidia-docker2 nfs-common gcc make net-tools


#time zone
timedatectl set-timezone 'Asia/Seoul'

#nouveau disable
vim /etc/modprobe.d/blacklist.conf
echo '#nouveau disable' >> /etc/modprobe.d/blacklist.conf
echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist.conf
echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist.conf
update-initramfs -u
reboot

##nvidia-driver


#450
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/450.80.02/NVIDIA-Linux-x86_64-450.80.02.run

#460
wget https://kr.download.nvidia.com/XFree86/Linux-x86_64/460.91.03/NVIDIA-Linux-x86_64-460.91.03.run

#510
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/510.73.05/NVIDIA-Linux-x86_64-510.73.05.run

#515
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/515.48.07/NVIDIA-Linux-x86_64-515.48.07.run


#CUDA
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda_11.3.0_465.19.01_linux.run
chmod +x ./${CUDA}

chmod +x ${nvida-driver}
./${nvidia-driver}
nvidia-smi -pm 1


##docker
#docker
vi /lib/systemd/system/docker.service
--data-root=/data1/docker

systemctl daemon-reload
systemctl stop docker.socket
systemctl stop docker
mv /var/lib/docker /data1/docker
systemctl start docker.socket
systemctl start docker

#docker compose
wget https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64
wget https://github.com/docker/compose/releases/download/v2.5.1/docker-compose-linux-x86_64
mv docker-compose-linux-x86_64 docker-compose
mv docker-compose /usr/libexec/docker/cli-plugins/
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# nfs - client
mkdir /nfs /nfs2 /nfs3
echo '172.31.20.101:/nfs      /nfs               nfs   defaults       0       0' >> /etc/fstab
echo '172.31.20.101:/nfs2      /nfs2               nfs   defaults       0       0' >> /etc/fstab
echo '172.31.20.102:/nfs/nfs3      /nfs3               nfs   defaults       0       0' >> /etc/fstab
mount -a

# nfs - server
#NFS1
# VUNO test Server
echo '/nfs    nfs-$TARGET_HOSTNAME(rw,no_root_squash)' >> etc/exports
echo '/nfs2    nfs-$TARGET_HOSTNAME(rw,no_root_squash)' >> etc/exports

# NFS2
# VUNO test Server
echo '/nfs/nfs3       nfs-$TARGET_HOSTNAME(rw,no_root_squash)' >> /etc/exports

# 

# VUNO test Server
echo '/nfs    192.168.20.70(rw,no_root_squash)' >> /etc/exports
echo '/nfs2    192.168.20.70(rw,no_root_squash)' >> /etc/exports

# NFS2
# VUNO test Server
echo '/nfs/nfs3       192.168.20.70(rw,no_root_squash)' >> /etc/exports