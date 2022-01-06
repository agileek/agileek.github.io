---
layout: post
title: "Repair your grub"
categories: [software, terminal]
date: 2021-12-24
tags: [software, grub, terminal, fedora]
---

## Context

Sometimes, when you upgrade your linux distribution, some stuff gets a little bit messed up. 
And sometimes, it get more messed up.
When weird stuff happens to your bootloader, everything you think you knew suddenly disappear, you don't have access to internet, nothing work anymore, and usually you are in a hurry to use your computer.
Take a deep breath, we are going to fix this.


## Steps

Get a live USB key, I usually have an ubuntu somewhere, if you don't, grab one, and put it on you usb key.

#### Live USB

first, type `dmesg -w` in your terminal then plug in the usb.

You should see something like that:
![dmesg][dmesg]{: .center-image }

In my case, that means my usb key is on sd**a**

{% include warning.html content="Be really careful, you could lose data" %}

Now download the linux distribution `curl https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-desktop-amd64.iso`, then copy it on your usb key:
`sudo dd if=./ubuntu-20.04.3-desktop-amd64.iso of=/dev/sda bs=4M status=progress`

And voilà!

#### Down the rabbit hole

Once you have booted on your usb key, you should be able to access your "real" filesystem in order to repair the bootloader.

Basically, we are going to mount the arborescence of your "real" machine on a subfolder of the current running linux, and chroot[^chroot] into it.

That's where it will differ depending on your setup:
- You could have encrypted your disk
- You could have a dual boot with windows (my case)

So let's create a folder first: `sudo mkdir /mnt/fedora`

Then we will mount our *root* filesystem into it: `sudo mount /dev/mapper/fedora-root /mnt/fedora`

Usually, you should have something under `/mnt/fedora/boot`.
If you don't you have a boot partition,  you should mount it `sudo mount /dev/nvme0n1p4 /mnt/fedora/boot`

Since I have a dual boot, I have a dedicated efi partition at the begining of my disk, that I need to mount too: `sudo mount /dev/nvme0n1p1 /mnt/fedora/boot/efi`

Now we are going to mount a bunch of stuff from our live distribution, to be able to run commands once we are in the jail.

{% highlight bash %}
cd /mnt/fedora
sudo mount -o bind /dev dev
sudo mount -o bind /proc proc
sudo mount -o bind /sys sys
sudo mount -t tmpfs tmpfs tmp
{% endhighlight %}

#### Okey let's go!

Let's go into the chroot: `sudo chroot /mnt/fedora`
{% include warning.html content="Backup your /boot/efi/EFI/fedora/grub.cfg" %}

Regenerate a new grub: `grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`

Reboot without the usb key, it should work now.

[dmesg]: /images/posts/repair-grub/dmesg_output.png
[^chroot]: For **ch**ange **root**, we will jail our process in the filesystem you just mounted
[source]: https://unix.stackexchange.com/questions/72592/chroot-in-to-reinstall-grub2-reinstall-mnt-is-empty
