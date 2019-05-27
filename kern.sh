#!/bin/bash

# sudo add-apt-repository ppa:graphics-drivers/ppa 

# sudo apt install kernel-package libncurses5 libncurses5-dev build-essential flex bison


dprint() {
    echo "---> ${@}" 2>&1
}

if [ "$1" == "clone" ]; then

    # clone linux source to new dir
    dprint "cloning kernel/git/stable/linux-stable"
    rm -rf linux.stable

    if [ "x${2}" == "xlinus" ]; then
        # linus tree
        git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux.stable
    else
        git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux.stable
    fi
    exit 0

elif [ "$1" == "pull" ]; then
    
    dprint "updating source tree"
    # update linux source from git
    cd linux.stable
    git pull
    git tag 

    exit 0

elif [ "$1" == "build" ]; then

    # create new copy of tree, patch it and build it
    BRANCH=$2
    rm -rf linux build
    #rsync -a --info=progress2 linux.stable/* linux/ 
    cp -R linux.stable linux
    cd linux
    
    if [ "x${BRANCH}" == "x" ]; then
        dprint "building master since no branch was provided"
        BRANCH='master'
    else
        dprint "building ${BRANCH}"
    fi

    git checkout ${BRANCH}

    #dprint "patching from aufs4"
    #patch -p1 --ignore-whitespace -i ../aufs4-standalone/aufs4-kbuild.patch
    #patch -p1 --ignore-whitespace -i ../aufs4-standalone/aufs4-base.patch
    #patch -p1 --ignore-whitespace -i ../aufs4-standalone/aufs4-mmap.patch
    #patch -p1 --ignore-whitespace -i ../aufs4-standalone/aufs4-standalone.patch

    #cp -R ../aufs4-standalone/Documentation .
    #cp -R ../aufs4-standalone/fs .
    #cp -R ../aufs4-standalone/include .

    #dprint "patched kernel source and copied aufs src files"

else
    dprint "must provide clone, build, or pull as parameter"
    exit 1
fi

# configure it
yes '' |make oldconfig

# enable AUFS from the patches above
sed -i 's/# CONFIG_AUFS_FS is not set/CONFIG_AUFS_FS=y/g' .config

# finally, build it
make -j `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-reeps

# move build output
cd ..
rm -rf build
mkdir build
mv linux-* build/

rm build/*-dbg_*.deb
sudo dpkg -i build/*.deb
