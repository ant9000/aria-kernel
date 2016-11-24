# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "antoniogalea/debian-jessie64-bigdisk"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 8
  end
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provision "shell", inline: <<-SHELL
    # setup base cross-build machine
    cp /vagrant/sources.list /etc/apt/
    chown root.root /etc/apt/sources.list
    echo "Acquire::Retries 5;" > /etc/apt/apt.conf.d/55retry-downloads
    apt-get update
    apt-get -y dist-upgrade
    apt-get -y install curl
    curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
    dpkg --add-architecture armel
    apt-get update
    apt-get -y install build-essential crossbuild-essential-armel git libncurses5-dev
  SHELL
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    git config --global user.name vagrant
    git config --global user.email vagrant@vagrant
    # download and prepare the kernel stuff
    cp /vagrant/kernel.sh /home/vagrant/
    cd /home/vagrant
    mkdir downloads
    cd downloads 
    wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.16.tar.xz
    wget https://raw.githubusercontent.com/AcmeSystems/acmepatches/master/linux-4.4.16.patch
    cd ..
    tar xf downloads/linux-4.4.16.tar.xz
    cd linux-4.4.16
    git init .
    git add .
    git commit -m "Linux vanilla"
    git checkout -b acme
    patch -p1 < ../downloads/linux-4.4.16.patch
    git add .
    git commit -m "ACME configs, dts and LCD panels" -a
    cd ..
    # compilation starts here
    ./kernel.sh
  SHELL
end
