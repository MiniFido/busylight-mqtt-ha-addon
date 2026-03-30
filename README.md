# Busylight MQTT Add-on for Home Assistant OS

A simple local add-on for **Home Assistant OS** that makes it possible to control a **Kuando / Plenom Busylight Alpha** over **MQTT**.

The add-on listens on an MQTT topic and forwards commands to the Busylight using `busylight-for-humans`.

## Features

- Control a Busylight Alpha over MQTT
- Supports commands such as:
  - `red`
  - `green`
  - `blue`
  - `off`
  - `black`
  - `blink_blue`
  - `list`
- Runs as a local add-on on Home Assistant OS
- Easy to use in Home Assistant automations and scripts

## Requirements

- Home Assistant OS
- Mosquitto Broker or another MQTT broker
- Kuando / Plenom Busylight Alpha connected over USB
- Local add-ons enabled through `/addons/local/`

## Installation

Copy the `busylight_mqtt` folder into:

```bash
/addons/local/



----------------------------------------------------
https://busylight.com/products/busylight-uc-alpha/