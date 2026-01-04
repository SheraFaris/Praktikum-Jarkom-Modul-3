#!/bin/bash
set -euo pipefail

# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan sebagai root: sudo $0"
  exit 1
fi

echo "[1] Membuat direktori web"
mkdir -p /var/www/jarkom

echo "[2] Membuat template HTML (profile_sciel.html)"
cat > /var/www/jarkom/profile_XXX.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
...
</html>
EOF

echo "[3] Konfigurasi nginx site jarkom"
cat > /etc/nginx/sites-available/jarkom <<'EOF'
server {

	listen 80;

	root /var/www/jarkom;

	index index.html index.htm;
	server_name _;

	location / {
			try_files $uri $uri/ /index.php?$query_string;
	}

	# pass PHP scripts to FastCGI server
	location ~ \.php$ {
	include snippets/fastcgi-php.conf;
	fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}

location ~ /\.ht {
			deny all;
	}

	error_log /tmp/error.log;
	access_log /tmp/access.log;
}
EOF

echo "[4] Enable site jarkom"
ln -sf /etc/nginx/sites-available/jarkom /etc/nginx/sites-enabled/jarkom

# (opsional tapi disarankan) disable default site
if [ -e /etc/nginx/sites-enabled/default ]; then
    rm -f /etc/nginx/sites-enabled/default
fi

echo "[5] Restart nginx"
nginx -t
service nginx restart

echo "✅ Nginx jarkom setup selesai."

# ----------------------------------------------------------------------
# chmod +x /root/script_dns_zones.sh
# ls -l /root/script_dns_zones.sh
# ./root/script_dns_zones.sh