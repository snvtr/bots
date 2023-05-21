#!/bin/bash

set -e

# update/install git, pip3
sudo apt update && sudo apt install -y git python3-pip

cd ~ || exit 1

# clone and install antispam-bot:
git clone https://github.com/snvtr/antispam-bot.git
cd ~/antispam-bot || exit 1
sudo mv antispam-bot.service /etc/systemd/system/
sudo cp /tmp/antispam-bot.env ~
sudo pip3 install -r requirements.txt

PYTHON_VER=$(python3 --version) && PYTHON_VER=${PYTHON_VER%.*} && PYTHON_VER=${PYTHON_VER/ /} && PYTHON_VER=$(echo $PYTHON_VER | tr [:upper:] [:lower:])
sudo pip3 install /tmp/egenix_telegram_antispam_bot-0.4.0-py3-none-any.whl
sudo cp challenge.py /usr/local/lib/${PYTHON_VER}/dist-packages/telegram_antispam_bot/

# clone and install kaztili-bot:
cd ~ && git clone https://github.com/snvtr/KaztiliSozdikBot.git
cd ~/KaztiliSozdikBot || exit 1
sudo mv kaztili-bot.service /etc/systemd/system/
sudo cp /tmp/kaztili-bot.env ~
sudo pip3 install -r requirements.txt
sudo chmod 0755 kaztili.py

# clone and install runcalc-bot:
cd ~ && git clone https://github.com/snvtr/runcalc-bot.git
cd ~/runcalc-bot || exit 1
sudo mv runcalc-bot.service /etc/systemd/system/
sudo cp /tmp/runcalc-bot.env ~
sudo pip3 install -r requirements.txt
sudo chmod 0755 aiogram_bot.py

sudo systemctl daemon-reload && exit 0

#
