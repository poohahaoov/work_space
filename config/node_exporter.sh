#!/bin/bash
#node_exporter conf file copy
cp /nfs3/test/node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
cp /nfs3/test/node_exporter.service /etc/systemd/system/

#node_exporter Service account create
useradd -M -r -s /bin/false node_exporter

#Service own change
chown node_exporter:node_exporter /etc/systemd/system/node_exporter.service

#daemon-reload
systemctl daemon-reload

#Service on
systemctl enable node_exporter.service --now

#Service status
systemctl status node_exporter.service