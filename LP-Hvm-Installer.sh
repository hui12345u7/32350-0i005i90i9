#!/bin/bash

clear

echo "==========================================="
echo "        ⚡ LIGHTINGPLAYS INSTALLER ⚡"
echo "==========================================="
echo ""
echo "1) HVM 5.1 Installer"
echo "2) LXC / LXD Installer"
echo "3) Cloudflare Setup"
echo ""

read -p "Enter choice [1-3]: " choice


# ===============================
# OPTION 1 : HVM 5.1 INSTALLER
# ===============================
if [ "$choice" == "1" ]; then

echo "Starting HVM 5.1 Installation..."

apt update -y
apt install git -y

git clone https://github.com/DreamHost2ws/HVM5.1
cd HVM5.1

apt update
apt install python3-pip -y

mkdir -p ~/.config/pip
echo -e "[global]\nbreak-system-packages = true" > ~/.config/pip/pip.conf

pip install -r requirements.txt

echo "Creating systemd service..."

cat <<EOF > /etc/systemd/system/hvm.service
[Unit]
Description=HVM Panel (Discord Bot)
After=network.target

[Service]
User=root
WorkingDirectory=/root/hvm
ExecStart=/usr/bin/python3 /root/hvm/hvm.py
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

echo "Starting HVM..."

python3 hvm-5.1.py


# ===============================
# OPTION 2 : LXC / LXD INSTALLER
# ===============================
elif [ "$choice" == "2" ]; then

echo "Starting LXC Installer..."

bash <(curl -fsSL https://raw.githubusercontent.com/hopingboyz/lxc-installer/main/lxc-installer.sh)


# ===============================
# OPTION 3 : CLOUDFLARE SETUP
# ===============================
elif [ "$choice" == "3" ]; then

echo "Installing Cloudflare Tunnel..."

sudo mkdir -p --mode=0755 /usr/share/keyrings

curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg \
| sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' \
| sudo tee /etc/apt/sources.list.d/cloudflared.list

sudo apt-get update
sudo apt-get install cloudflared -y

echo ""
read -p "Enter your Cloudflare Tunnel Token: " token

cloudflared service install $token

echo ""
echo "Cloudflare Tunnel Installed Successfully!"


# ===============================
# INVALID OPTION
# ===============================
else

echo "Invalid option selected!"

fi
