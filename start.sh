#!/bin/bash

cd /root/project
npm install --production
npm run-script staging
while true; do echo \"running...\"; sleep 1; done
