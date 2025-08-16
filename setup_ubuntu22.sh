#!/bin/bash
set -e

echo "[1/6] 시스템 업데이트..."
sudo apt update && sudo apt upgrade -y

echo "[2/6] 기본 개발 툴 설치..."
sudo apt install -y build-essential cmake gcc g++ git pkg-config curl wget \
    software-properties-common lsb-release ca-certificates vim gedit

echo "[3/6] Docker & 컨테이너 도구 설치..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io \
    docker-compose-plugin docker-buildx-plugin

sudo usermod -aG docker $USER

echo "[4/6] Chrome 139, VS Code, Unity Hub, Arduino IDE, Raspberry Pi Imager 설치..."

# Google Chrome 139 설치 + 자동 업데이트 차단
wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_139.0.7258.127-1_amd64.deb
sudo apt install -y ./google-chrome-stable_139.0.7258.127-1_amd64.deb
rm google-chrome-stable_139.0.7258.127-1_amd64.deb
sudo apt-mark hold google-chrome-stable

# VSCode 설치 
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code terminator

# Unity Hub 설치
wget -O unityhub.deb https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage.deb
sudo apt install -y ./unityhub.deb
rm unityhub.deb

# Arduino IDE 설치
wget -O arduino-ide.deb https://downloads.arduino.cc/arduino-ide/2.3.21/arduino-ide_2.3.21_Linux_64bit.deb
sudo apt install -y ./arduino-ide.deb
rm arduino-ide.deb

# Raspberry Pi Imager 설치
wget -O rpi-imager.deb https://downloads.raspberrypi.org/imager/imager_latest_amd64.deb
sudo apt install -y ./rpi-imager.deb
rm rpi-imager.deb

echo "[5/6] ROS 2 Humble 설치..."
sudo apt install -y curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
  http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt install -y ros-humble-desktop ros-dev-tools python3-colcon-common-extensions \
    python3-rosdep python3-roslaunch python3-vcstool python3-argcomplete \
    python3-flake8 python3-pytest-* \
    ros-humble-*

# rosdep init
sudo rosdep init || true
rosdep update

echo "[6/6] 한국어 환경 설치..."
sudo apt install -y kime

echo "✅ 설치 완료! 재부팅해주세요!"
