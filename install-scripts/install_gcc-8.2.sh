#!/bin/bash
set -x

# Install gcc 8.2
mkdir -p /tmp/setup-gcc
cd /tmp/setup-gcc

wget ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
tar -xvf gmp-6.1.0.tar.bz2
cd ./gmp-6.1.0
./configure && make -j 40 &&  make install
cd ..

wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
tar -xvf mpfr-3.1.4.tar.bz2
cd mpfr-3.1.4
./configure && make -j 40 &&  make install
cd ..

wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
tar -xvf mpc-1.0.3.tar.gz
cd mpc-1.0.3
./configure && make -j 40 &&  make install
cd ..

# install gcc 8.2
wget https://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.gz
tar -xvf gcc-6.2.0.tar.gz
cd gcc-6.2.0
./configure --disable-multilib --prefix=/opt/gcc-6.2.0 && make -j 40 && make install

cd && rm -rf /tmp/setup-gcc

gcc_path="export PATH=/opt/gcc-6.2.0/bin:$PATH
export LD_LIBRARY_PATH=/opt/gcc-6.2.0/lib64:$LD_LIBRARY_PATH
export CC=/opt/gcc-6.2.0/bin/gcc
export GCC=/opt/gcc-6.2.0/bin/gcc"

#set env on /mnt/shared/ which can be used when launched after VM is generalized
echo -e "$gcc_path" >> /mnt/shared/setenv
chmod 755 /mnt/shared/setenv
