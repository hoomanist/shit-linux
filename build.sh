#!/bin/sh
place=$(pwd)
custom=$place/build.sh
target=`realpath $1`


msg(){
	printf "\033[1m\033[32m => $@\033[m\n"
}


msg "build busybox"
cd packages/busybox
make clean
make -j $(nproc) CC=gcc
make CONFIG_PREFIX=$target install
cd $place

msg "build musl"
cd packages/musl-1.2.0
make clean
./configure --prefix=$target/usr
make -j $(nproc)
make install
cd $place

msg "build llvm-lld"
cd packages/llvm-project
make clean
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=lld -DCMAKE_INSTALL_PREFIX=$target/usr lld
make install -j $(nproc)
cd $place

msg "build llvm-clang"
cd packages/llvm-project
make clean
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=lld -DCMAKE_INSTALL_PREFIX=$target/usr clang 
make install -j $(nproc) 
cd $place

msg "build elfutils"
cd packages/elfutils
autoreconf -i -f
./configure --prefix=$target/usr --enable-maintainer-mode 
make -j $(nproc)
make install


#msg "build tcc"
#cd packages/tinycc
#./configure --prefix=$target/usr
#make -j $(nproc)
#make install destdir=$target/usr
#cd $place



#msg "build git"
#cd packages/git
#./configure  CC=musl-gcc --prefix=$target/usr
#make LDFLAGS="-static" CC=musl-gcc -j $(nproc) 
#make install LDFLAGS="-static" CC=musl-gcc  prefix=$target/usr
#cd $place

#msg "build make"
#cd packages/make-4.2.93
#./configure --prefix=$target/usr
#make LDFLAGS="-static" -j $(nproc)
#make install LDFLAGS="-static" destdir=$target/usr
#cd $place

msg "system directories"
mkdir $target/proc $target/sys $target/dev
cp $place/init.sh $target/bin/init


msg "base build completed"
