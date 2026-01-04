# Script ini untuk menjawab soal 2-3

#!/bin/bash
set -euo pipefail

# pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan sebagai root: sudo $0"
  exit 1
fi

echo "[1] Update & install bind9 ... No internet!"
#apt-get update -y
#apt-get install -y bind9

echo "[2] Pastikan folder zone ada"
mkdir -p /etc/bind/jarkom

echo "[3] Konfigurasi named.conf.local"
cat > /etc/bind/named.conf.local <<'EOF'
zone "lune33.com" {
    type master;
    notify yes;
    also-notify { 192.168.3.3; };
    allow-transfer { 192.168.3.3; };
    file "/etc/bind/jarkom/lune33.com";
};

zone "sciel33.com" {
    type master;
    notify yes;
    also-notify { 192.168.3.3; };
    allow-transfer { 192.168.3.3; };
    file "/etc/bind/jarkom/sciel33.com";
};

zone "gustave33.com" {
    type master;
    notify yes;
    also-notify { 192.168.3.3; };
    allow-transfer { 192.168.3.3; };
    file "/etc/bind/jarkom/gustave33.com";
};

zone "expeditioners.com" {
    type master;
    notify yes;
    also-notify { 192.168.3.3; };
    allow-transfer { 192.168.3.3; };
    file "/etc/bind/db.expeditioners.com";
};

# Reverse DNS Lookup
zone "2.168.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.168.3.3; };
    allow-transfer { 192.168.3.3; };
    file "/etc/bind/jarkom/2.168.192.in-addr.arpa";
};
EOF

echo "[4] Restart bind9"
service named restart

echo "[5] Status bind9"
service named status

echo "✅ DNS Master configuration selesai."

# ----------------------------------------------------------------------
# nano /root/script_dns_master.sh
# chmod +x /root/script_dns_master.sh
# ls -l /root/script_dns_master.sh
# ./root/script_dns_master.sh

