ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv \
    bash \
    hidapi \
    libusb

RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --no-cache-dir paho-mqtt busylight-for-humans

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]