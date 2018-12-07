#!/bin/sh

set -e

base=$(ls Dockerfile-[0-9\.]* | tail -n 1)
img=$(grep FROM $base | awk '{print $2}')

qemu_ver=$(wget -qO - "https://api.github.com/repos/multiarch/qemu-user-static/releases/latest" | grep '"tag_name":' |sed -E 's/.*"([^"]+)".*/\1/')

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
		wget -q https://github.com/multiarch/qemu-user-static/releases/download/$qemu_ver/qemu-$qemu_arch-static
		chmod +x qemu-$qemu_arch-static
	fi
	echo "ARG img=$img" >> $df

    echo $qemu_ver | grep -q v3
    if [ "$?" = "0" -a "$qemu_arch" = "s390x" ]; then # QEMU too old to support STCK instruction
        wget -O Dockerfile-qemu-$qemu_arch.tmp https://github.com/qemu/qemu/raw/master/tests/docker/dockerfiles/ubuntu.docker
        echo "RUN git clone https://github.com/patchew-project/qemu && cd qemu && git checkout tags/patchew/20181130192216.26987-1-richard.henderson@linaro.org && ./configure --static --disable-system --enable-linux-user --target-list=$qemu_arch-linux-user --disable-glusterfs --disable-gtk --disable-vte --disable-vnc --disable-opengl --disable-gnutls --disable-nettle --prefix=/usr/local && make -j 8 && make install && cd .. && rm -r qemu" >> Dockerfile-qemu-$qemu_arch.tmp
        docker build -t qemu-$qemu_arch -f Dockerfile-qemu-$qemu_arch.tmp .
        id=$(docker create qemu-$qemu_arch)
        docker cp $id:/usr/local/bin/qemu-$qemu_arch ./qemu-$qemu_arch-static
        docker rm -v $id
    fi

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat Dockerfile-qemu-head | grep -v '^ARG .*=' >> $df
	else
		cat Dockerfile-qemu-head | grep 'FROM.*arch.*img' >> $df
	fi

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat $base | grep -v ':amd64' | grep -v '^FROM ' | grep -v scafacos >> $df
	else
		cat $base | grep -v ':amd64' | grep -v '^FROM ' >> $df
	fi

	if [ "$os_arch" != "amd64" -a "$os_arch" != "i386" ]; then
		cat Dockerfile-qemu-tail >> $df
	fi
done
