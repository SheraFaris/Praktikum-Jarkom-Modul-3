#!/bin/bash
# script_reverse_proxy.sh
# Soal 9: Reverse Proxy di Alicia untuk domain expeditioners.com
# - /profil_lune    -> Lune (profile_lune.html)
# - /profil_sciel   -> Sciel (profile_sciel.html)
# - /profil_gustave -> Gustave (profile_gustave33.html)
# - selain itu      -> Halaman informasi Lune (port 8000)

set -euo pipefail

echo "[1] Tulis konfigurasi reverse proxy soal 9+10"
cat > /etc/nginx/sites-available/expeditioners <<EOF
upstream expedition_info_rr {
    server 192.168.2.2:8000;    # Lune info
    server 192.168.2.3:8100;    # Sciel info
    server 192.168.2.4:8200;    # Gustave info
}

server {
    listen 80;
    server_name expeditioners.com;

    # /profil_lune -> Web Server Lune
    location = /profil_lune {
        proxy_pass http://192.168.2.2/profile_lune.html;
    }

    # /profil_sciel -> Web Server Sciel
    location = /profil_sciel {
        proxy_pass http://192.168.2.3/profile_sciel.html;
    }

    # /profil_gustave -> Web Server Gustave
    location = /profil_gustave {
        proxy_pass http://192.168.2.4/profile_gustave.html;
    }


    location / {
        proxy_pass http://expedition_info_rr;
    }
}
EOF

echo "[2] Enable site expeditioners (idempotent)"
ln -sf /etc/nginx/sites-available/expeditioners /etc/nginx/sites-enabled/expeditioners

echo "[3] Disable default site supaya tidak bentrok"
if [ -e /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

echo "[4] Test config & reload nginx"
nginx -t
service nginx restart

echo "=== SELESAI ==="
echo "Tes (dari client yang DNS/hosts sudah mengarah ke IP Alicia):"

# Selain URL profil -> Halaman Informasi Lune
#location / {
#    proxy_pass http://192.168.2.4:8000;
#}