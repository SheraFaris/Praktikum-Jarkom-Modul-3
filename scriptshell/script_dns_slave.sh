#!/bin/bash
set -euo pipefail

# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan sebagai root: sudo $0"
  exit 1
fi

echo "[1] Pastikan direktori zone ada"
mkdir -p /etc/bind/jarkom

echo "[2] Konfigurasi named.conf.local (DNS SLAVE)"
cat > /etc/bind/named.conf.local <<'EOF'
zone "lune33.com" {
    type slave;
    masters { 192.168.3.2; };
    file "/etc/bind/jarkom/lune33.com";
};

zone "sciel33.com" {
    type slave;
    masters { 192.168.3.2; };
    file "/etc/bind/jarkom/sciel33.com";
};

zone "gustave33.com" {
    type slave;
    masters { 192.168.3.2; };
    file "/etc/bind/jarkom/gustave33.com";
};

# Reverse DNS (SLAVE)
zone "2.168.192.in-addr.arpa" {
    type slave;
    masters { 192.168.3.2; };
    file "/etc/bind/jarkom/2.168.192.in-addr.arpa";
};

# Delegated subdomain (SLAVE)
zone "expedition.gustave33.com" {
    type master;
    file "/etc/bind/jarkom/expedition.gustave33.com";
};
EOF

echo "[3] Tulis zone expedition.gustave33.com"
cat > /etc/bind/jarkom/expedition.gustave33.com <<'EOF'
$TTL    604800
@       IN      SOA     ns.expedition.gustave33.com. root.expedition.gustave33.com. (
                        2026010202 ; Serial
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      ns.expedition.gustave33.com.
ns      IN      A       192.168.3.3
@       IN      A       192.168.2.4
EOF

echo "[4] Restart DNS service (auto-detect)"
service named restart
service named status


echo "[5] Selesai"
echo " ^|^e DNS Slave (Verso) berhasil dikonfigurasi."

# ----------------------------------------------------------------------
# chmod +x /root/script_dns_slave.sh
# ls -l /root/script_dns_slave.sh
# ./root/script_dns_slave.sh