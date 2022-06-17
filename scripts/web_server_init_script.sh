#!/bin/bash
apt update -y
apt install -y nginx
systemctl start nginx
systemctl enable nginx
rm /etc/nginx/sites-enabled/default
wget -O /etc/nginx/sites-enabled/api.conf https://raw.githubusercontent.com/isagues/terraform-demo/main/scripts/api.conf
systemctl reload nginx