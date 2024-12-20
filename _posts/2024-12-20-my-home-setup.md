---
layout: post
title: 'My home setup'
categories: [home_automation, software]
date: 2024-12-20
tags: [software, home_automation]
---

This article will be a work in progress for as long as I play with home automation stuff

## Context

I have been geeking aroung my home for a few years now.\
I have learned a lot, and still have a lot to learn...\
I have been frustrated by the state of the industry around open standards, interconnectivity and such.


## What I want

I want everything to work in my house even if my home automation system is down.\
Every wall socket must work, every switch must work, no surprises.\
I want as much offline stuff as possible, wired if possible.


## What I don't want

I don't want proprietary lightbulb/wallplug... connected to the internet.\
I want as less WiFi as possible.


## What I have

### Software

* Home assistant
* Zigbee2MQTT
* Adguard home
* ESPHome


### Hardware

* Rpi 3
* Intel NUC
* RazBerry
* Sonoff Zigbee USB Dongle USB
* RFXCom
* KLF200


#### Control the lights

For "simple" switchs, I use [Sonoff zbmini][zbmini].\
It's easy, you can hide them behind the wall switch, the ceiling lamp.\
They release the [L2][L2] version where you don't need a neutral anymore.

For dimmers, I have some zwave devices, because I couldn't find the zigbee equivalent yet.\
I use the [Fibaro FGD212][FGD212] and they work really well.\
They have a neat hack, where you can trigger custom stuff on triple click (they call it scene activation).\
I shutdown all my ground floor by triple clicking my living room's wall switch.


For "smart plugs", I used these [sonoff smart switches][BASICZBR3] but now I'm rather happy with the [S26R2ZB][S26R2ZB], the only missing thing is the device consumption.

#### Control the heating

I have 2 different needs.

The first one is controling the hvac system I have in my office ( it is located outside the house, in the garage, and is not part of the home heating system).\
Before the HVAC system I had a simple electric radiator and it was easy to control through home assistant, that way I could heat it before having to work.\
Now I have a Toshiba RAS-B05E2KVG-E and it's quite difficult to interact with it without the official remote, so I setup a little esp32 with an IR transmitter and it seems to work.\
I still have to play with it before talking more about it.


My second need is controlling the home heating system.\
Right now I have an Atlantic air-to-water HVAC and it works really well.\
But since it is some IO-home control stuff, it's kind of difficult to plug it to a home automation system (that is, without spending a few hundred € for a proprietary sh*t connected to my WiFi).\
And of course, the KLF200, which an IO homecontrol box, does not work with the heating systems.\
Noooo, you have to buy a whole new box just for that.\
I have heard of some project working on a somfy hack that could allow us to get rid of this IO homecontrol monopoly.


#### Control the shutters

I had no choice, with our veranda came some roller shutter by Somfy.
And worse of it, Somfy IO.\
They have their shitty home-control protocol and everything is really expensive, not really easy to interconnect, so if you can, avoid them.\
My first solution was to solder a remote control I bought on EBay, and it worked great. Not having the states of my shutters really bothered me, though, so in the end I stopped using this.\
I waited for some "Black friday sale" and bought a KLF200.
It works quite well and, of course, it's been discontinued by velux so it's difficult to find them anymore...


#### Sensors

I have two different wireless technology for the sensors.\
I started with the 433.92Mhz.\
They are cheap, resistant (I have one of them in my freezer, the triggers alarms in case the temperature rises too much, it works really well), and are quite resilient, and, if your sensor is in range of your receiver, it will work really well (I even receive my neighbours sensors...)


Now that I have a correct zigbee network, I have some [temperature/humidity][snzb-02] sensors and I'm quite happy with them.\ Even though I don't like having the CR2032 battery.

I also played with [Wireless Door/Window Sensor][snzb-04] but I find them quite unreliable, and I won't rely on them to build a home alarm system.

I tried a [motion sensor][snzb-03], it seems to work well, but I don't really have a scenario to use them.\
I tried pairing them with a light to automatically switch a light when motion is detected but I find it really slow to detect/light, so, in stairs for example it's not really practical.\
I'll try it outdoor to light the garage door at nigth, maybe it'll be more useful.


#### Garden

I'm afraid of messing with the water system, so I haven't done anything yet, except some automatic garden lights, but still have some DIY ideas.


#### Zigbee

With zigbee2mqtt I discovered that we can link two components together, so they can work autonomously.\
For example I have a [motion sensor][snzb-03] that can be paired with [a smart switch][zbmini].\
That works really great, and the good part is, if your box is down, it still works, they are full autonomous.\
Unfortunately, a lot of zigbee sensors does not expose the right commands and you can't do that with everything.

For example the [Wireless Door/Window Sensor][snzb-04] does not expose the right command so it's impossible to directly pair them with something else, and you have to do a home assistant automation if you want to link them with something else.

[zbmini]: https://sonoff.tech/product/diy-smart-switches/zbmini/
[L2]: https://sonoff.tech/product/diy-smart-switches/zbmini-l2/
[FGD212]: https://manuals.fibaro.com/dimmer-2/
[BASICZBR3]: https://sonoff.tech/product-document/diy-smart-switches-doc/basiczbr3-doc/
[S26R2ZB]: https://sonoff.tech/product/s26r2zb/
[snzb-02]: https://sonoff.tech/product/gateway-and-sensors/snzb-02/
[snzb-04]: https://sonoff.tech/product/gateway-and-sensors/snzb-04/
[snzb-03]: https://sonoff.tech/product/gateway-and-sensors/snzb-03/
