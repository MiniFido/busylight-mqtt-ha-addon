#!/usr/bin/with-contenv bashio

set -x

MQTT_HOST=$(bashio::config 'mqtt_host')
MQTT_PORT=$(bashio::config 'mqtt_port')
MQTT_USER=$(bashio::config 'mqtt_user')
MQTT_PASSWORD=$(bashio::config 'mqtt_password')
MQTT_TOPIC=$(bashio::config 'mqtt_topic')

export MQTT_HOST
export MQTT_PORT
export MQTT_USER
export MQTT_PASSWORD
export MQTT_TOPIC
export PATH="/opt/venv/bin:$PATH"

echo "Starting Busylight MQTT bridge..."
echo "MQTT host: ${MQTT_HOST}"
echo "MQTT topic: ${MQTT_TOPIC}"

/opt/venv/bin/python -u - <<'PY'
import os
import subprocess
import traceback
import paho.mqtt.client as mqtt

TOPIC = os.environ["MQTT_TOPIC"]
HOST = os.environ["MQTT_HOST"]
PORT = int(os.environ["MQTT_PORT"])
USER = os.environ.get("MQTT_USER", "")
PASSWORD = os.environ.get("MQTT_PASSWORD", "")

current_proc = None

def stop_current():
    global current_proc
    if current_proc and current_proc.poll() is None:
        print(f"Stopping running process pid={current_proc.pid}", flush=True)
        try:
            current_proc.terminate()
            current_proc.wait(timeout=2)
        except Exception:
            try:
                current_proc.kill()
            except Exception:
                pass
    current_proc = None

def run_blocking(cmd):
    print("RUN:", " ".join(cmd), flush=True)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
    print("STDOUT:", result.stdout.strip(), flush=True)
    print("STDERR:", result.stderr.strip(), flush=True)
    print("RC:", result.returncode, flush=True)
    return result.returncode

def run_background(cmd):
    global current_proc
    stop_current()
    print("START BG:", " ".join(cmd), flush=True)
    current_proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    print(f"BG pid={current_proc.pid}", flush=True)

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT rc={rc}", flush=True)
    client.subscribe(TOPIC)
    print(f"Subscribed to {TOPIC}", flush=True)

def on_message(client, userdata, msg):
    payload = msg.payload.decode("utf-8", errors="ignore").strip().lower()
    print(f"MQTT message on {msg.topic}: {payload}", flush=True)

    try:
        if payload == "red":
            run_background(["/opt/venv/bin/busylight", "on", "red"])
        elif payload == "green":
            run_background(["/opt/venv/bin/busylight", "on", "green"])
        elif payload == "blue":
            run_background(["/opt/venv/bin/busylight", "on", "blue"])
        elif payload == "blink_blue":
            run_background(["/opt/venv/bin/busylight", "blink", "blue"])
        elif payload == "black":
            run_background(["/opt/venv/bin/busylight", "on", "black"])
        elif payload == "off":
            stop_current()
            run_blocking(["/opt/venv/bin/busylight", "off"])
        elif payload == "list":
            run_blocking(["/opt/venv/bin/busylight", "list"])
        else:
            print(f"Unknown payload: {payload}", flush=True)
    except Exception:
        traceback.print_exc()

client = mqtt.Client()
if USER:
    client.username_pw_set(USER, PASSWORD)

client.on_connect = on_connect
client.on_message = on_message
client.connect(HOST, PORT, 60)
client.loop_forever()
PY