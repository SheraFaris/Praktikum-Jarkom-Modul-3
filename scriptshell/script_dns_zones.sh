# Script ini untuk menjawab soal 2-3


#!/bin/bash
set -euo pipefail

# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan sebagai root: sudo $0"
  exit 1
fi

echo "[1/7] Pastikan direktori zone ada"
mkdir -p /etc/bind/jarkom

echo "[2/7] Tulis zone lune33.com"
cat > /etc/bind/jarkom/lune33.com <<'EOF'
$TTL    604800
@       IN      SOA     ns.lune33.com. root.lune33.com. (
                        2026010202 ; Serial
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      ns.lune33.com.
ns      IN      A       192.168.3.2
@       IN      A       192.168.2.2
exp     IN      CNAME   lune33.com.
EOF

echo "[3/7] Tulis zone sciel33.com"
cat > /etc/bind/jarkom/sciel33.com <<'EOF'
$TTL    604800
@       IN      SOA     ns.sciel33.com. root.sciel33.com. (
                        2026010203 ; Serial
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      ns.sciel33.com.
ns      IN      A       192.168.3.2
@       IN      A       192.168.2.3
exp     IN      CNAME   sciel33.com.
EOF

echo "[4/7] Tulis zone gustave33.com"
cat > /etc/bind/jarkom/gustave33.com <<'EOF'
$TTL    604800
@       IN      SOA     ns.gustave33.com. root.gustave33.com. (
                        2026010203 ; Serial
                        604800
                        86400
                        2419200
                        604800 )

@               IN      NS      ns.gustave33.com.
ns              IN      A       192.168.3.2
@               IN      A       192.168.2.4

expedition      IN      NS      ns.expedition.gustave33.com.

ns.expedition   IN      A       192.168.3.3


EOF

echo "[5/7] Tulis reverse zone 2.168.192.in-addr.arpa"
cat > /etc/bind/jarkom/2.168.192.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     ns.gustave33.com. root.gustave33.com. (
                        2026010202 ; Serial
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      ns.gustave33.com.
4       IN      PTR     gustave33.com.
EOF


echo "[7/7] Restart bind9"
service named restart

echo "✅ Semua file zone DNS berhasil dibuat dan bind9 direstart."

# ----------------------------------------------------------------------
# chmod +x /root/script_dns_zones.sh
# ls -l /root/script_dns_zones.sh
# ./root/script_dns_zones.sh