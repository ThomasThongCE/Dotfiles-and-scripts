#!/usr/bin/env bash

sudo cp systemd/set_charge_limit.service /etc/systemd/system/set_charge_limit.service
sudo cp systemd/enable-wol@.service /etc/systemd/system/enable-wol@.service

# Find ethernet interface (interface name start with e or en
ETH_INTERFACE=$(ip --brief link | awk '{print $1}' | grep -E '^e|^en' | tr -d '\n')

sudo systemctl daemon-reload
sudo systemctl enable set_charge_limit.service
sudo systemctl enable enable-wol@$ETH_INTERFACE.service
sudo systemctl start set_charge_limit.service
sudo systemctl start enable-wol@$ETH_INTERFACE.service

