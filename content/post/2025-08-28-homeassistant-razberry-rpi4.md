---
categories:
- software
date: "2025-09-28T00:00:00Z"
tags: ["software"]
title: Migrate homeassistant to RPI4 with an old RaZBerry
summary: How to spend a fun afternoon
---

My home assistant is running since the dawn of time on an old RPI3.

A while ago, I had a new deprecation warning, saying that the 32bits systems were not being supported anymore and that I should migrate to a 64bit system.

So here I am, with a RPI4, home assistant OS installed, and the backup exported.

Everything worked, except my old RazBerry module.

Impossible to get the /dev/ttyAMA0 to appear on the machine, and my searches did not help me at all.

I vaguely remembered that I had to enable UART at some point, so that's what I tried to do. I had no idea how hard it will be.

In the end, it's quite easy, but it took me most of a sunday afternoon to do.

So here goes, if someone is in this situation again, I hope it will help you.

## Activate root ssh

Not mandatory, you can access the SD card directly and go to the next step.

From [here][sshhomeassistant], you have to:

* use a USB key with a partition named CONFIG (ext4, FAT or NTFS)
* put a file named authorized_keys at the root of this partition with your ssh public key
* plug the key into your home assistant RPI and type `ha os import` (or reboot your home assistant)

You should be able to connect to the home assistant with `ssh root@youripaddress -p 22222`

## Enable UART

Once ssh connected, edit /mnt/boot/config.txt, you should have this part uncommented:

```
# Uncomment this to enable GPIO support for RPI-RF-MOD/HM-MOD-RPI-PCB
enable_uart=1
dtparam=i2c_arm=on
dtoverlay=miniuart-bt
#dtoverlay=rpi-rf-mod
```
[sshhomeassistant]: https://developers.home-assistant.io/docs/operating-system/debugging/
