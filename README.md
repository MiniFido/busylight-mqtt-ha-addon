# Busylight MQTT Add-on for Home Assistant OS

Et simpelt local add-on til **Home Assistant OS**, som gør det muligt at styre en **Kuando / Plenom Busylight Alpha** via **MQTT**.

Add-on’et lytter på et MQTT-topic og sender kommandoer videre til Busylighten via `busylight-for-humans`.

## Hvad den kan

- Styre Busylight Alpha via MQTT
- Understøtter farver som:
  - `red`
  - `green`
  - `blue`
  - `off`
  - `black`
  - `blink_blue`
  - `list`
- Kører som local add-on i Home Assistant OS

## Krav

- Home Assistant OS
- Mosquitto Broker eller anden MQTT broker
- Kuando / Plenom Busylight Alpha sat til via USB
- Local add-ons aktiveret via `/addons/local/`

## Installation

Kopiér mappen `busylight_mqtt` til:

```bash
/addons/local/