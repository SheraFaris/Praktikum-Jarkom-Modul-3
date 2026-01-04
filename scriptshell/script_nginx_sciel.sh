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
cat > /var/www/jarkom/profile_sciel.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sciel</title>
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
    <h1>Sciel</h1>
    <p><i>“Tomorrow comes.”</i></p>

    <h2>Core Expertise</h2>
    <ul>
      <li>Stealth and Infiltration Tactics</li>
      <li>Long-Range Surveillance</li>
      <li>Navigation and Terrain Mapping</li>
      <li>Rapid Response & Target Acquisition</li>
    </ul>

    <h2>Profile Summary</h2>
    <p>Sciel serves as the eyes and ears of Expedition 33. 
       Agile and perceptive, he scouts ahead, tracks enemy movement, 
       and secures safe passage before every major confrontation.</p>
  </div>

  <footer>© 2025 Expedition 33 — For Those Who Come After</footer>
</body>
</html>
EOF

echo "[2.1] Membuat halaman informasi bersama (info.html) — SAMAKAN di semua node"
cat > /var/www/jarkom/info.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Expedition 33 — Mission Brief</title>
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
  header {
    text-align: center;
    padding: 3rem 1rem 1rem;
  }
  header h1 {
    font-size: 2.8rem;
    color: #00e5ff;
    letter-spacing: 1px;
    text-shadow: 0 0 10px #00e5ff;
  }
  header p {
    font-size: 1rem;
    color: #b5eaff;
    margin-top: 0.3rem;
  }
  .container {
    max-width: 700px;
    margin: 2rem auto 3rem;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 16px;
    padding: 2rem 2.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.4);
    backdrop-filter: blur(6px);
  }
  h2 {
    color: #00e5ff;
    margin-top: 1.5rem;
  }
  p, li {
    line-height: 1.6;
  }
  ul {
    list-style: none;
    padding: 0;
  }
  li {
    margin: 0.4rem 0;
  }
  strong {
    color: #ffd166;
  }
  .motto {
    text-align: center;
    margin-top: 1.5rem;
    font-style: italic;
    color: #ccc;
    opacity: 0.9;
  }
  footer {
    text-align: center;
    font-size: 0.9rem;
    color: #ddd;
    padding: 1rem;
    background: rgba(0,0,0,0.4);
  }
</style>
</head>
<body>
<header>
  <h1>Expedition 33</h1>
  <p>Mission Log #E33-00</p>
</header>

<div class="container">
  <h2>Mission Brief</h2>
  <p>Expedition 33 is a digital exploration led by <strong>Lune</strong>, <strong>Sciel</strong>, and <strong>Gustave</strong>.  
     Together, they traverse the unknown layers of the Paintress system — seeking order within chaos.</p>

  <h2>Active Nodes</h2>
  <ul>
    <li><strong>Lune</strong> — “When one falls, we continue.”</li>
    <li><strong>Sciel</strong> — “Tomorrow comes.”</li>
    <li><strong>Gustave</strong> — “For those who come after. Right?”</li>
  </ul>

  <h2>Ports</h2>
  <ul>
    <li>Lune: Port <strong>8000</strong></li>
    <li>Sciel: Port <strong>8100</strong></li>
    <li>Gustave: Port <strong>8200</strong></li>
  </ul>

  <div class="motto">
    “Despite the odds, Expedition 33 marches forward.”
  </div>
</div>

<footer>
  © 2025 Expedition 33 — For Those Who Come After
</footer>
</body>
</html>
EOF


echo "[3] Menambahkan custom log_format ke nginx.conf (idempotent)"
cat > /etc/nginx/conf.d/jarkom_log.conf <<'EOF'
log_format jarkom_log
    '[$time_local] '
    'Jarkom Node Sciel '
    'Access from $remote_addr '
    'using method "$request" '
    'returned status $status '
    'with $body_bytes_sent bytes sent '
    'in $request_time seconds';
EOF

echo "[4] Konfigurasi nginx site jarkom"
cat > /etc/nginx/sites-available/jarkom <<'EOF'
server {

        listen 80;

        root /var/www/jarkom;

        index ;
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

server {
    listen 8100;

    server_name _;

    root /var/www/jarkom;
    index info.html;

    location / {
        try_files $uri $uri/ =404;
    }

    error_log /tmp/info_error.log;
    access_log /tmp/info_access.log jarkom_log;
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
# nano /root/script_nginx_sciel.sh
# chmod +x /root/script_nginx_sciel.sh
# ls -l /root/script_nginx_sciel.sh
# ./root/script_nginx_sciel.sh
