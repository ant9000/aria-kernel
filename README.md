# aria-kernel

This Vagrantfile creates a Debian Jessie VM, preparing it as a cross-compiling machine for Acmesystems Aria G25.
Updated for Linux kernel 4.4.16.

## prerequisites

- [Vagrant](https://www.vagrantup.com/downloads.html), with plugin vagrant-vbguest (``vagrant plugin install vagrant-vbguest``)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- internet connectivity

## usage

`` vagrant up ``

The initial provisioning will download and install the toolchain and build a kernel for you, but it will take some time.

To access the VM, use

`` vagrant ssh ``

The current folder on the host will be synced with `/vagrant` inside the VM.

## Kernel

Kernel stuff is organized as follows:
- /home/vagrant/linux-4.4.16 contains the kernel tree
- /home/vagrant/build is the out-of-tree build directory

To produce a custom kernel:
```
cd /home/vagrant
./kernel.sh menuconfig
```

At the end, /vagrant/deploy will contain the stuff to be deployed on the board.
The folder /vagrant is kept in sync with the host, so you can access the files
from outside the VM without any special trick.
