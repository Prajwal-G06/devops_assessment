#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y docker.io
sudo apt-get install -y docker-compose

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu
sudo systemctl restart docker