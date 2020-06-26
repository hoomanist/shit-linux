#!/bin/sh
place=$(pwd)

msg(){
	printf "\033[1m\033[32m => $@\033[m\n"
}


msg "build busybox"
cd packages/busybox
make -j $(nproc)
make CONFIG_PREFIX=$1 install
cd $place


msg "build musl"
cd packages/musl-1.2.0
./configure --prefix=$1/usr
make -j $(nproc)
make install destdir=$1/usr
cd $place

msg "build tcc"
cd packages/tinycc
./configure --prefix=$1/usr
make -j $(nproc)
make install destdir=$1/usr
cd $place

msg "build git"
cd packages/git-2.27.0
./configure --prefix=$(realpath $1)/usr
make LDFLAGS="-static" -j $(nproc)
make install LDFLAGS="-static" destdir=$1/usr
cd $place

msg "build make"
cd packages/make-4.2.93
./configure --prefix=$1/usr
make LDFLAGS="-static" -j $(nproc)
make install LDFLAGS="-static" destdir=$1/usr
cd $place

msg "system directories"
mkdir $1/proc $1/sys $1/dev
cp $place/init.sh $1/bin/init


msg "base build completed"
