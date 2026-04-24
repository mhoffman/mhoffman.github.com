---
layout: default
title: Build Your Own Drone
---

# Build Your Own Drone

You can buy a drone. You should probably buy a drone. But if you want to understand what's inside one, you have to build it, and the only way to build one well is to make every mistake available to you along the way.

This isn't a step-by-step. It's the list of things I wish someone had told me before I started.

### Get the license first

Drones are small but they hit hard. Europe regulates accordingly. A1/A3 is the entry tier: liability insurance, 45 euros in fees, half a day of study, filed through the [Luftfahrt-Bundesamt](https://lba-openuav.de/einstieg/). A2 is the bigger one; you don't need it to start. Indoors you fly what you want.  Outdoor flight in the EU needs Remote ID broadcast. Check [dipul](https://maptool-dipul.dfs.de/) before you leave the house.

### Sourcing

Berlin is a drone desert. [Segor](https://www.segor.de/) in Charlottenburg is the only walk-in electronics store worth visiting. The staff are excellent, but they stock sensors, soldering gear, and XT connectors, not drone parts. Hamburg has [n-factory.de](https://n-factory.de/), Prague has [rotorama.com](https://www.rotorama.com/), Remagen has [fpv24.com](https://www.fpv24.com/de/). They all ship, you just wait a few days.

I knew I wanted to start indoors, so I picked a small frame. Here's what I actually bought, spring 2026 prices, assuming you start with nothing but a laptop.

### Shopping list

**Bare metal drone**

- _Frame_: SpeedyBee Bee35 3.5", 41.09 EUR
- _Motors_: four FlyfishRC Flash 1804 2450Kv, 65.96 EUR
- _FC + ESC stack_: MicoAir H743 + 50A BLS, 90.39 EUR
- _Propellers_: HQProp T3.5X2.5X3 3.5" grey, 2.26 EUR per set of four. Buy at least four sets; you will break propellers. Check the hub matches your motor shaft. Mine is 1.5 mm with one screw each side.
- _Battery_: Tattu R-Line 4S 750 mAh 95C LiPo with XT30, 19.95 EUR

**Sensors**

- Optical flow and 8 m lidar: MicoAir MTF-01, 26.69 EUR
- GPS with compass: MicoAir MG-A01, 13.89 EUR

**Everything else**

- _LiPo charger_: SkyRC S100 Neo, 1–6S 10A AC / 200W DC, 48.75 EUR
- _LiPo safety bag_, 12.90 EUR
- _Soldering kit_: temperature-controlled iron, solder, flux. Reichelt or Segor.
- _Transmitter_: RadioMaster TX15 Hot Pink or similar ELRS handset, 180 EUR
- _Receiver_: ELRS RP3 Nano, 27.90 EUR
- _Zip ties_
- _Vifly ShortSaver V2_, 13.49 EUR. Protects against shorts during bench work, which is a category of accident you will at some point have.
- _M2 screw set_, 8 EUR
- _XT60 ↔ XT30 adapters_: the battery in this BOM ships XT30 but the drone and charger want XT60. You need at least one adapter cable. Motors pull serious current, which is why these connectors exist at all; XT90 is the next tier up, but you won't meet it at this scale.
- _CH340 USB-UART adapter_ for flashing, 2–10 EUR
- _Flashing cables from MacBook_: one USB-C dongle, one USB-to-XT60 for 5V bench power, one USB-to-UART (the CH340). Pre-made works. I soldered mine; it's 3.3V and 5V, nothing to fear. **One rule, no exceptions: never connect the LiPo and the USB-UART at the same time.** You will learn this by blowing a USB port. Buy a couple of cheap dongles up front.

### Assembly

It isn't hard. It just takes patience.

Mount the ESC to the frame. Mount the motors to the frame. Solder the motor wires to the ESC pads. Solder the ESC power input to the battery lead, through the capacitor that keeps the drone from becoming an accidental radio. Connect the FC to the ESC with the supplied cable.

Leave the propellers off. You'll run a lot of bench tests before first flight, and every one of them is safer and faster without spinning blades. This [video](https://youtu.be/BcaN7pahC88?si=WNXMKCe4lmTnjkAw) walked me through the physical assembly order the first time.

### The firmware

Betaflight, ArduPilot, and PX4 all fly drones well and have been debugged by people more patient than you. If your goal is to fly, pick one.

I wanted to write mine in Rust. If you're going to make every mistake on purpose, you might as well pick the hardest ones.

Learn Rust first. The [book](https://doc.rust-lang.org/book/) is good, the [interactive version](https://rust-book.cs.brown.edu/) is better, [Rustlings](https://rustlings.rust-lang.org/) makes the syntax stick. Then clone [holsatus-flight](https://github.com/holsatus/holsatus-flight), which is the sanest starting point that exists for Rust drone firmware. Depending on your hardware you'll write drivers, logging, and safety interlocks along the way.

Holsatus ships with a Rapier3d-based rigid body simulator that runs at 600× real time.  Coarse PID tuning against a sim costs zero propellers.

Prevent the drone from arming unless the SD card is inserted. Otherwise you will loose valuable logging information from each crash. Prevent the Makefile from flashing unless you have a clean repo and include the git sha in the log output

Build three kill paths before anything flies:

- flip detected (attitude past a sane angle)
- gyro runaway (angular rate past a sane limit)
- manual kill via the ELRS transmitter

The first two save the drone. The third saves your furniture.

### PID Tuning

In order to fly at any rate or point the firmware uses various PID controls which depend on the exact dimensions and weights on your drone. To determine moments of inertia use the bifilar pendulum test which means you suspend the drone for each of the 3 dimension with two strings, flip it 15-20 degrees and measure the time for each period it takes to swing back and forth and use the following formula

$$
I = \frac{m g d^2 T^2}{16 \pi^2 L}
$$
where $m$ is mass of drone, $g$ is gravity, $d$ is distance between strings, $T$ is duration of period, $L$ is length of strings.

### Flashing and binding, the non-obvious parts

To flash firmware: connect the CH340 to the FC's UART pads, then connect USB power to the ESC's XT60. Before you apply power, hold the BOOT button on the FC. Apply power. Wait one second. Release BOOT. The drone is now in DFU mode and ready to accept a firmware image.

To bind the ELRS transmitter to the receiver: power-cycle the drone three times. Three. Not two, not four. The receiver LED will settle into blink-blink-gap, which means it's waiting for a partner. On the transmitter, go to System → ELRS → Bind. Done.

Neither of these rituals is written down in any one place. Both will cost you an evening the first time.

### Pre-flight checklist

- All propellers attached, oriented consistently for the frame (props-in or props-out, not mixed)
- Propellers free of cracks and bends.
- Battery strapped firmly, centered on the frame's CG mark
- SD card in the FC if you want flight logs
- Finger on the kill switch from arm to disarm

Bare floors are bad for the optical flow sensor, some newspaper taped to the ground will help.

The first hover is anticlimactic. The drone lifts off, holds position for a moment, settles back to the floor. You sit there grinning.
