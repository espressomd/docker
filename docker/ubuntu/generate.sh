#!/bin/sh

base=$(ls Dockerfile-[0-9\.]* | tail -n 1)
img=$(grep FROM $base | awk '{print $2}')

for os_arch in $*; do

	case $os_arch in
		arm64)
			arch=arm64v8
			qemu_arch=aarch64
		;;
		armhf)
			arch=arm32v7
			qemu_arch=arm
		;;
		*)
			arch=$os_arch
			qemu_arch=$os_arch
	esac

	df=Dockerfile-$os_arch.tmp

	echo "ARG arch=$arch" > $df
	echo "ARG qemu_arch=$qemu_arch" >> $df
	echo "ARG img=$img" >> $df

	cat Dockerfile-arch | grep -v '^ARG .*=' >> $df
	cat $base | grep -v ':amd64' | grep -v '^FROM ' >> $df

done
