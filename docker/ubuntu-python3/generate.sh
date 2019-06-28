#!/bin/sh

set -e

base=$(ls Dockerfile-[0-9\.]* | tail -n 1)
img=$(grep FROM $base | awk '{print $2}')

qemu_ver=$(wget -qO - "https://api.github.com/repos/multiarch/qemu-user-static/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

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
		qemu_download_ver=$qemu_ver
		if [ "$os_arch" = "ppc64le" -a "$(echo $qemu_ver | cut -d - -f 1)" = "v4.0.0" ]; then
			# arithmetic seems to be broken in this version
			qemu_download_ver="v3.1.0-3"
		fi
		wget -q https://github.com/multiarch/qemu-user-static/releases/download/$qemu_download_ver/qemu-$qemu_arch-static
		chmod +x qemu-$qemu_arch-static
	fi

	echo "ARG img=$img" >> $df

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat Dockerfile-qemu-head | grep -v '^ARG .*=' >> $df
	else
		cat Dockerfile-qemu-head | grep 'FROM.*arch.*img' >> $df
	fi

	if [ "$os_arch" != "amd64" ]; then
		cat $base | grep -v ':amd64' | grep -v '^FROM ' | grep -v scafacos >> $df
	else
		cat $base | grep -v ':amd64' | grep -v '^FROM ' >> $df
	fi

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat Dockerfile-qemu-tail >> $df
	fi

	if [ "$os_arch" = "armhf" -o "$os_arch" = "i386" ]; then
		cat Dockerfile-inode-tail >> $df
	fi
done
