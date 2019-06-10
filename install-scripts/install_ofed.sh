#!/bin/bash

set -x

#yum install -y pciutils lsof ethtool libnl3 libmnl tcsh

#!/bin/bash

set -x

# Install Mellanox OFED
mkdir -p /tmp/mlnxofed
cd /tmp/mlnxofed
wget http://www.mellanox.com/downloads/ofed/MLNX_OFED-4.6-1.0.1.1/MLNX_OFED_LINUX-4.6-1.0.1.1-rhel7.6-x86_64.tgz
tar zxvf MLNX_OFED_LINUX-4.6-1.0.1.1-rhel7.6-x86_64.tgz

KERNEL=$(uname -r)
./MLNX_OFED_LINUX-4.6-1.0.1.1-rhel7.6-x86_64/mlnxofedinstall --kernel-sources /usr/src/kernels/$KERNEL --add-kernel-support --skip-repo
cd && rm -rf /tmp/mlnxofed

sed -i 's/LOAD_EIPOIB=no/LOAD_EIPOIB=yes/g' /etc/infiniband/openib.conf
/etc/init.d/openibd restart
cd && rm -rf /tmp/mlnxofed

# Install WALinuxAgent
mkdir -p /tmp/wala
cd /tmp/wala
wget https://github.com/Azure/WALinuxAgent/archive/v2.2.38.tar.gz
tar -xvf v2.2.38.tar.gz
cd WALinuxAgent-2.2.38
python setup.py install --register-service --force
sed -i -e 's/# OS.EnableRDMA=y/OS.EnableRDMA=y/g' /etc/waagent.conf
sed -i -e 's/AutoUpdate.Enabled=y/# AutoUpdate.Enabled=y/g' /etc/waagent.conf
systemctl restart waagent
cd && rm -rf /tmp/wala

