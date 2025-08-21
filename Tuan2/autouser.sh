#!/bin/bash

read -p "Enter new username: " username
read -s -p "Enter new password: " password
echo
sudo useradd -m "$username"
echo "$username:$password" | sudo passwd