#!/bin/bash

yum remove package wazuh-agent -y
systemctl disable wazuh-agent
systemctl daemon-reload
