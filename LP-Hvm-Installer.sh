#!/bin/bash

clear

# ==========================
# OS DETECTION
# ==========================

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS."
    exit 1
fi

if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
    echo "Unsupported OS: $OS"
    echo "This installer supports Ubuntu and Debian only."
    exit 1
fi

echo "Detected OS: $OS"
sleep 2
clear

# ==========================
# BANNER
# ==========================

echo "==========================================="
echo "        ⚡ AyushTheWarrior INSTALLER ⚡"
echo "==========================================="
echo ""
echo "1) HVM 5.1 Installer"
echo "2) LXC / LXD Installer"
echo "3) Cloudflare Setup"
echo ""

read -p "Enter choice [1-3]: " choice


# ===============================
# OPTION 1 : HVM INSTALLER
# ===============================

if [ "$choice" == "1" ]; then

apt update -y
apt install git -y

git clone https://github.com/hui12345u7/32350-0i005i90i9
cd 32350-0i005i90i9

apt update
apt install python3-pip -y

mkdir -p ~/.config/pip
echo -e "[global]\nbreak-system-packages = true" > ~/.config/pip/pip.conf

pip install -r requirements.txt

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

python3 hvm-5.1.py


# ===============================
# OPTION 2 : LXC INSTALLER
# ===============================

elif [ "$choice" == "2" ]; then

bash <(curl -fsSL https://raw.githubusercontent.com/OfficialCodesHub/One-click-Cmds/refs/heads/main/lxd%20installer)


# ===============================
# OPTION 3 : CLOUDFLARE SETUP
# ===============================

elif [ "$choice" == "3" ]; then

sudo mkdir -p --mode=0755 /usr/share/keyrings

curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg \
| sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' \
| sudo tee /etc/apt/sources.list.d/cloudflared.list

sudo apt-get update
sudo apt-get install cloudflared -y

read -p "Enter your Cloudflare Tunnel Token: " token

cloudflared service install $token

# ===============================
# INVALID OPTION
# ===============================

else

echo "Invalid option selected."

fi
