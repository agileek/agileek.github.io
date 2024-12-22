---
categories: home_automation
date: "2015-12-05T00:00:00Z"
tags:
  - domoticz
  - docker
  - raspberryPi
title: Raspberry Pi, RFXCom and Domoticz
---

This begins a serie of home automation articles.


## First step
![phenix][phenix]
I recommend to start with something easy.

I tried a remote controllable wall socket a few years ago, and it really works very well. I use it to control 4 lights area in my living room.


***Now it's time to take it to the next level!***

## Choose wisely

There are 2 main wireless protocols to communicate with your devices, 433.92 MHz and Z-wave.

433.92 MHz is just the communication frequency, and every constructor implements its own protocol.

There are a lot of devices you can find using 433.92 MHz, but if you want to control everything, you'll need something generic.

Here comes the [rfxcom][rfxcom].

> In the world of domotics you can order your equipment from a wide range of suppliers.

It's a usb device that receives and sends signals via 433.92 MHz.

With that tool I needed a "home brain", something that could control various stuff.

After some digging (and advices from [Florian Chauveau][nanak]), I decided to use [domoticz][domoticz].

## Glue it all together

### Docker on raspberry pi

![raspberrypi][raspberrypi]

I recommend to look at [https://github.com/fchauveau/rpi-domoticz-docker][rpi-domoticz-docker], everything is explained:

- Setup an image on your sdcard with docker 32bits installed
- Build the rpi-domoticz-docker image on your raspberry (optional if you pull it from the registry)

### Recipe
Here is what I did

- Download a docker ready image for your sdcard at [http://blog.hypriot.com/downloads/][hypriot]
- Copy the image to the sdcard
  - ```sudo dd if=hypriot-rpi-20151103-224349.img of=/dev/mmcblk0 bs=1M```
- Start your raspberry
- Plug in the rfxcom
- Connect to it via ssh (root/hypriot)
- Get the latest rpi-domoticz-docker
  - ```docker pull agileek/rpi-domoticz-docker```
- Launch it
  - ```docker run --device=/dev/ttyUSB0 -p 8080:8080 -d agileek/rpi-domoticz-docker```
	  - Backup ```-v /root/domoticz.db:/root/domoticz/domoticz.db```
- Connect to domoticz http://mydomoticzserveraddress:8080

Don't forget to add the rfxcom to the hardware list and enjoy!

[phenix]: /images/posts/home_automation/yc-4000s.jpg
[rfxcom]: http://www.rfxcom.com/en_GB
[nanak]: https://twitter.com/florianchauveau
[domoticz]: https://domoticz.com/
[raspberrypi]: /images/posts/home_automation/raspberry_pi_logo.svg
[rpi-domoticz-docker]: https://github.com/fchauveau/rpi-domoticz-docker
[hypriot]: http://blog.hypriot.com/downloads/
