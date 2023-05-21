#!/bin/bash

set -e

# update/install git, pip3
sudo apt update && apt install -y git python3-pip 

USER_NAME=$(cat files/user.env)

# create user
sudo useradd -m -s /bin/bash $USER_NAME
sudo mkdir ~${USER_NAME}/.ssh/ && cp ~ubuntu/.ssh/* ${USER_NAME}/.ssh/
sudo chown ${USER_NAME}.${USER_NAME} ~${USER_NAME}/.ssh/*

cd "~${USER_NAME}" || exit 1

# clone and install antispam-bot:
git clone git@github.com:snvtr/antispam-bot.git
cd ~${USER_NAME}/antispam-bot || exit 1
sed -i "s|{{ UserName }}|$USER_NAME|g" antispam-bot.service
sudo cp antispam-bot.service /etc/systemd/system/
sudo pip3 -install requirements.txt

PYTHON_VER=$(python3 --version) && PYTHON_VER=${PYTHON_VER%.*} && PYTHON_VER=${PYTHON_VER/ /} && PYTHON_VER=$(echo $PYTHON_VER | tr [:upper:] [:lower:])
sudo pip3 install /tmp/egenix_telegram_antispam_bot-0.4.0-py3-none-any.whl
sudo cp challenge.py /usr/local/lib/${PYTHON_VER}/telegram_antispam_bot/

# clone and install kaztili-bot:
git clone git@github.com:snvtr/KaztiliSozdikBot.git
cd ~${USER_NAME}/KaztiliSozdikBot || exit 1
sed -i "s|{{ UserName }}|$USER_NAME|g" kaztili-bot.service
sudo cp kaztili-bot.service /etc/systemd/system/
pip3 -install requirements.txt
sudo chmod 0755 aiogram_bot.py

# clone and install runcalc-bot:
git clone git@github.com:snvtr/runcalc-bot.git
cd ~${USER_NAME}/runcalc-bot || exit 1
sed -i "s|{{ UserName }}|$USER_NAME|g" runcalc-bot.service
sudo cp runcalc-bot.service /etc/systemd/system/
pip3 -install requirements.txt
sudo chmod 0755 aiogram_bot.py

sudo systemctl daemon-reload

#sudo userdel -r ubuntu

#