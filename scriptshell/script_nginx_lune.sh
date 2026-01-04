#!/bin/bash
set -euo pipefail


# Pastikan dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "Jalankan sebagai root: sudo $0"
  exit 1
fi

echo "[1] Membuat direktori web"
mkdir -p /var/www/jarkom

echo "[2] Membuat template HTML (profile_lune.html)"
cat > /var/www/jarkom/profile_lune.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lune</title>
<style>
  body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    color: #fff;
    background: linear-gradient(270deg, #0a043c, #4a0c25, #7b1b0c, #f9a826);
    background-size: 800% 800%;
    animation: bgShift 20s ease infinite;
  }
  @keyframes bgShift {
    0% {background-position: 0% 50%;}
    50% {background-position: 100% 50%;}
    100% {background-position: 0% 50%;}
  }
  .container {
    max-width: 700px;
    margin: 4rem auto;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 16px;
    padding: 2.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.5);
    backdrop-filter: blur(6px);
  }
  h1 {
    text-align: center;
    color: #00e5ff;
    text-shadow: 0 0 10px #00e5ff;
  }
  h2 {
    color: #ffd166;
    margin-top: 1.5rem;
  }
  p, li { line-height: 1.6; }
  ul { list-style: none; padding-left: 0; }
  li::before { content: "▹ "; color: #00e5ff; }
  footer { text-align: center; font-size: 0.85rem; color: #ccc; margin-top: 2rem; }
</style>
</head>
<body>
  <div class="container">
    <h1>Lune</h1>
    <p><i>“When one falls, we continue.”</i></p>

    <h2>Core Expertise</h2>
    <ul>
      <li>Analysis of Ancient Technologies</li>
      <li>Equipment Calibration & Field Maintenance</li>
      <li>Defense System Deployment</li>
      <li>Data Collection & Anomaly Detection</li>
    </ul>

    <h2>Profile Summary</h2>
    <p>Lune is the mind behind the expedition’s technology. 
       Her understanding of ancient mechanisms and magical artifacts 
       is key to decoding the Paintress’ secrets and keeping the team operational.</p>
  </div>

  <footer>© 2025 Expedition 33 — For Those Who Come After</footer>
</body>
</html>EOF



echo "[3] Menambahkan custom log_format ke nginx.conf (idempotent)"
cat > /etc/nginx/conf.d/jarkom_log.conf <<'EOF'
log_format jarkom_log
    '[$time_local] '
    'Jarkom Node Lune '
    'Access from $remote_addr '
    'using method "$request" '
    'returned status $status '
    'with $body_bytes_sent bytes sent '
    'in $request_time seconds';
EOF

echo "[4] Konfigurasi nginx site jarkom"
cat > /etc/nginx/sites-available/jarkom <<'EOF'
server {

        listen 8080;
        listen 8888;

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
        access_log /tmp/access.log jarkom_log;
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

echo " ^|^e Nginx jarkom setup selesai."

# ----------------------------------------------------------------------
# chmod +x /root/script_dns_zones.sh
# ls -l /root/script_dns_zones.sh
# ./root/script_dns_zones.sh
