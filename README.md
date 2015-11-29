About Little Vagant Machine
================================

Greeting fellows, thank you for your interesting.

This is a Vagrant machine init script set for creating a instant working Vagrant machine for you.

AND it will save you plenty of time because when machine is ready, you don't need to do many configuration.


How to use it?
--------------------------

You may take following few steps in order to use this script:


### Install Virtual Box

Virtual Box is a Free virtual machine platform available on Mac, Linux and Windows etc, you may need it if you don't have another virtual machine platform currently installed.

To install Virtual Box, please go to https://www.virtualbox.org/


### Install Vagrant

Visit: http://www.vagrantup.com/downloads.html

Please select the distribution made for your operating system, and follow the instruction to install.

*Normally you just need double-click on that file.*


### Install Git

You need Git to clone this repository.

#### Windows users

Please visit: https://windows.github.com/
Or: https://www.sourcetreeapp.com/

#### Linux users

##### dnf

Please use command

    sudo dnf install git

##### apt-get

Please use command

    sudo apt-get install git

#### Mac

Please visit: [The How To Manual](http://www.lmgtfy.com/?q=Install+Git+on+my+Mac)


### Clone this repository

    mkdir My Vagrants
    cd My Vagrants
    git clone https://github.com/raincious/little-vagrant-machine.git
    cd little-vagrant-machine


### Do a little configuration

#### Setup your own DNS name

This Vagrant init script come with domain `lo.3ax.org` used to create Apache sites, you can change that using command:

    cat 'YourLocalDomain.dev' > Vagrant/domain

Don't forget to change your local DNS server to point your `*.YourLocalDomain.dev` to `127.0.0.1`.


#### Create your own CA certificate

This Vagrant init script need `CA.crt` and `CA.key` located inside the `Vagrant` folder to create HTTPS website for Apache.

You can replace the default `CA.crt` and `CA.key` by your own one.

In order to create certificates on Unix liked system, you need *OpenSSL*, you can install it by

    sudo apt-get *OR* yum install openssl

And then, use following command to create your own CA certificate

    openssl genrsa -out Vagrant/CA.key 4096
    openssl req -new -x509 -days 365 -key Vagrant/CA.key -out Vagrant/CA.crt

The last `openssl` command will ask you some questions, please answer it accordingly.


### Move your project to synced folder

You need to move your project to one of the synced folders so applications (Apache etc) inside the Vagrant machine can read it.

You will find following synced folders come with this init script

* **Project** - The projects you will develop with this VM
* **Test** - Some scripts you put there for test
* **Tool** - Some tool scripts (like phpMyAdmin etc) you used to manage this VM

*Notice that: We don't offer any tools with the VM, you need to get them ready by yourself.*

Now, create a folder in the `Project` folder, the folder name must in range `[a-z0-9\-]+`, and the '-' can't be at begining and end.

Once you done, move your project into that new folder. If you have not only one project, repeat those steps until every needed project is moved in.


### Init your Vagrant

Make sure you have connected into Internet, and type-in command

    vagrant up

then punch Enter key.

It will take long time for first-time boot up, please wait until anything is done.


What's in there
--------------------------

We currently had following few set ups.

### PHP

It will install Apache + PHP + PostgreSQL + Memcached into the new Vagrant VM, and build Apache Virtual Host for every each host with SSL support.

Default Apache port is `8080` for HTTP access and `4443` for HTTPS access. Every each VH is configured to use domain to access, so `localhost:8080` or `127.0.0.1:4443` is not available. You can get their domain name after the init has finished.

Default user for PostgreSQL is `dev`, you can login with password `dev`. You can manage your database with GUI tool `pgAdmin` outside the VM with port `55432`.

Memcached is running it's default port, with no access form outside, you can change that by re-configure it.

See After-Finish message for detail.

#### On Destroy

The data in PostgreSQL is stroaged inside the VM, you need to back them up manually before exec `vagrant destroy` command, or the data will be lost.


Credits
--------------------------
This project is inspired by wgammi's [vagrant-nginx-php-postgres-redis](https://github.com/wgammi/vagrant-nginx-php-postgres-redis) project.


Made by
--------------------------
raincious@gmail.com
