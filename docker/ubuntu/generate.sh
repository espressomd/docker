#!/bin/sh

set -e

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
	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		echo "ARG qemu_arch=$qemu_arch" >> $df
	fi
	echo "ARG img=$img" >> $df

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat Dockerfile-arch | grep -v '^ARG .*=' >> $df
	else
		cat Dockerfile-arch | grep 'FROM.*arch.*img' >> $df
	fi

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat $base | grep -v ':amd64' | grep -v '^FROM ' | grep -v scafacos >> $df
	else
		cat $base | grep -v ':amd64' | grep -v '^FROM ' >> $df
	fi

done
