#/bin/sh


export PATH=/bin:/usr/bin
clear

msg(){
	printf "\033[1m=> $@\033[m\n"
}

msg "hello there"

msg "mount filesystems"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

msg "system started :|"
/bin/sh -l
