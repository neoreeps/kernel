# ubuntu / debian kernel
Build script for my kernel that includes aufs patches, output is an installed kernel.

This script will create a local copy of your source dir (so you don't have reverse patches) and then build there ... this will keep your source clean (yes, you can git checkout . etc etc but why?)

This is my daily script that I use to build in about 30min (Dell Precision 5520 Laptop, i7-7820HQ, 32GB Mem, 1TB NVMe)

# Instructions

**Step 1:** Clone AUFS repository as a subdir in this repository
This script adds AUFS functionality for those of us with docker images on aufs.

```
git clone git@github.com:sfjro/aufs-standalone
cd aufs-standalone
git checkout aufs4.x-rcN
cd ..
```

**Step 2:** Clone linux kernel repo
Here is a choice to clone either the linux stable tree or Linus stable tree ... Linus tree will be more current but may miss a patch or two and may be less stable.
To clone linux-stable:
```
./kern.sh clone
```

To clone Linus tree:
```
./kern.sh clone linus
```

**Step 3:** Update your source and list the tags
```
./kern.sh pull
```

Filter the list of tags via grep:
```
./kern.sh pull |grep v4.17
```

**Step 4:** Finally, build and install your kernel
```
./kern.sh build v4.17-rc7
```
