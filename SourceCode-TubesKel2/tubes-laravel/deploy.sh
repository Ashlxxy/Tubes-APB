#!/bin/bash

# ============================================================
# UKM Band Laravel Deployment Script (Caddy Version)
# Domain: ukm-band.cyshe.my.id
# Run as root: sudo bash deploy.sh
# ============================================================

set -e

# Configuration - EDIT THESE
DOMAIN="ukm-band.cyshe.my.id"
APP_DIR="/var/www/ukm-band"
DB_NAME="ukm_band"
DB_USER="ukm_band_user"
DB_PASSWORD="$(openssl rand -base64 16)"
APP_KEY=""  # Will be generated
GITHUB_REPO="https://github.com/Ashlxxy/Tubes-Kelompok2-WebProPBO.git"
PHP_VERSION="8.4"
CADDYFILE="/root/Caddyfile"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

echo "============================================================"
echo "  UKM Band Laravel Deployment Script (Caddy)"
echo "  Domain: $DOMAIN"
echo "============================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root: sudo bash deploy.sh"
    exit 1
fi

# ============================================================
# 1. SYSTEM UPDATE
# ============================================================
print_status "Updating system packages..."
apt update && apt upgrade -y

# ============================================================
# 2. INSTALL REQUIRED PACKAGES
# ============================================================
print_status "Installing essential packages..."
apt install -y software-properties-common curl wget git unzip zip

# ============================================================
# 3. INSTALL PHP 8.4
# ============================================================
print_status "Adding PHP repository..."
add-apt-repository -y ppa:ondrej/php
apt update

print_status "Installing PHP $PHP_VERSION and extensions..."
apt install -y php$PHP_VERSION \
    php$PHP_VERSION-fpm \
    php$PHP_VERSION-cli \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-zip \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-bcmath \
    php$PHP_VERSION-intl \
    php$PHP_VERSION-readline \
    php$PHP_VERSION-opcache

# Set PHP 8.4 as default CLI
update-alternatives --set php /usr/bin/php$PHP_VERSION 2>/dev/null || true
update-alternatives --set phar /usr/bin/phar$PHP_VERSION 2>/dev/null || true

# Start PHP-FPM
systemctl enable php$PHP_VERSION-fpm
systemctl start php$PHP_VERSION-fpm

# ============================================================
# 4. INSTALL MYSQL (if not already installed)
# ============================================================
if ! command -v mysql &> /dev/null; then
    print_status "Installing MySQL Server..."
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
else
    print_status "MySQL already installed, skipping..."
fi

# ============================================================
# 5. CREATE DATABASE AND USER
# ============================================================
print_status "Creating database and user..."
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

print_status "Database '$DB_NAME' created with user '$DB_USER'"

# ============================================================
# 6. INSTALL PHPMYADMIN
# ============================================================
if [ ! -d "/usr/share/phpmyadmin" ]; then
    print_status "Installing phpMyAdmin..."
    DEBIAN_FRONTEND=noninteractive apt install -y phpmyadmin
else
    print_status "phpMyAdmin already installed, skipping..."
fi

# ============================================================
# 7. INSTALL COMPOSER
# ============================================================
if ! command -v composer &> /dev/null; then
    print_status "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    chmod +x /usr/local/bin/composer
else
    print_status "Composer already installed, skipping..."
fi

# ============================================================
# 8. INSTALL NODE.JS (for frontend assets)
# ============================================================
if ! command -v node &> /dev/null; then
    print_status "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
else
    print_status "Node.js already installed, skipping..."
fi

# ============================================================
# 9. CLONE REPOSITORY
# ============================================================
print_status "Cloning repository..."
rm -rf $APP_DIR
mkdir -p $APP_DIR
git clone $GITHUB_REPO $APP_DIR/temp
mv $APP_DIR/temp/tubes-laravel/* $APP_DIR/
mv $APP_DIR/temp/tubes-laravel/.* $APP_DIR/ 2>/dev/null || true
rm -rf $APP_DIR/temp

# ============================================================
# 10. INSTALL LARAVEL DEPENDENCIES
# ============================================================
print_status "Installing Laravel dependencies..."
cd $APP_DIR
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --optimize-autoloader --no-dev

# ============================================================
# 11. CONFIGURE ENVIRONMENT
# ============================================================
print_status "Configuring environment..."

# Generate .env file
cat > $APP_DIR/.env << EOF
APP_NAME="UKM Band"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_TIMEZONE=Asia/Jakarta
APP_URL=https://$DOMAIN

APP_LOCALE=id
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=id_ID

APP_MAINTENANCE_DRIVER=file

PHP_CLI_SERVER_WORKERS=4

BCRYPT_ROUNDS=12

LOG_CHANNEL=stack
LOG_STACK=single
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASSWORD

SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null

BROADCAST_CONNECTION=log
FILESYSTEM_DISK=local
QUEUE_CONNECTION=database

CACHE_STORE=file
CACHE_PREFIX=

MAIL_MAILER=log
MAIL_HOST=127.0.0.1
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@$DOMAIN"
MAIL_FROM_NAME="\${APP_NAME}"
EOF

# Generate application key
cd $APP_DIR
php artisan key:generate --force

# ============================================================
# 12. SET PERMISSIONS
# ============================================================
print_status "Setting permissions..."
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR
chmod -R 775 $APP_DIR/storage $APP_DIR/bootstrap/cache
mkdir -p $APP_DIR/public/uploads
chmod -R 775 $APP_DIR/public/uploads
mkdir -p $APP_DIR/public/assets/audio
chmod -R 775 $APP_DIR/public/assets
chown -R www-data:www-data $APP_DIR/public

# ============================================================
# 13. RUN MIGRATIONS
# ============================================================
print_status "Running database migrations..."
cd $APP_DIR
php artisan migrate --force
php artisan db:seed --force 2>/dev/null || true

# ============================================================
# 14. OPTIMIZE LARAVEL
# ============================================================
print_status "Optimizing Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan storage:link

# ============================================================
# 15. CONFIGURE CADDY
# ============================================================
print_status "Configuring Caddy..."

# Backup existing Caddyfile
cp $CADDYFILE ${CADDYFILE}.backup 2>/dev/null || true

# Create phpMyAdmin symlink
mkdir -p /var/www/phpmyadmin
ln -sf /usr/share/phpmyadmin /var/www/phpmyadmin/public 2>/dev/null || true

# Append new site to Caddyfile
cat >> $CADDYFILE << 'CADDY_CONF'

# UKM Band Laravel Application
ukm-band.cyshe.my.id {
    root * /var/www/ukm-band/public
    
    # Enable file server
    file_server
    
    # PHP-FPM
    php_fastcgi unix//run/php/php8.4-fpm.sock
    
    # Encode responses
    encode gzip zstd
    
    # Handle Laravel routing
    try_files {path} {path}/ /index.php?{query}
    
    # Security headers
    header {
        X-Frame-Options "SAMEORIGIN"
        X-Content-Type-Options "nosniff"
        -Server
    }
    
    # Logging
    log {
        output file /var/log/caddy/ukm-band.log
    }
    
    # Handle phpMyAdmin at /phpmyadmin
    handle_path /phpmyadmin* {
        root * /usr/share/phpmyadmin
        php_fastcgi unix//run/php/php8.4-fpm.sock
        file_server
    }
}
CADDY_CONF

# Create log directory
mkdir -p /var/log/caddy
chown caddy:caddy /var/log/caddy

# Reload Caddy
print_status "Reloading Caddy..."
systemctl reload caddy || caddy reload --config $CADDYFILE

# ============================================================
# 16. CONFIGURE FIREWALL
# ============================================================
print_status "Configuring firewall..."
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow OpenSSH
echo "y" | ufw enable 2>/dev/null || true

# ============================================================
# 17. CREATE SYSTEMD SERVICE FOR QUEUE WORKER
# ============================================================
print_status "Creating queue worker service..."
cat > /etc/systemd/system/ukm-band-queue.service << EOF
[Unit]
Description=UKM Band Queue Worker
After=network.target

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php $APP_DIR/artisan queue:work --sleep=3 --tries=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ukm-band-queue
systemctl start ukm-band-queue

# ============================================================
# DEPLOYMENT COMPLETE
# ============================================================
echo ""
echo "============================================================"
echo -e "${GREEN}  DEPLOYMENT COMPLETE!${NC}"
echo "============================================================"
echo ""
echo "🌐 Website URL: https://$DOMAIN"
echo "🗄️  phpMyAdmin: https://$DOMAIN/phpmyadmin"
echo ""
echo "📋 Database Credentials:"
echo "   Database: $DB_NAME"
echo "   Username: $DB_USER"
echo "   Password: $DB_PASSWORD"
echo ""
echo "📁 App Directory: $APP_DIR"
echo ""
echo "⚠️  IMPORTANT: Save these credentials securely!"
echo ""
echo "============================================================"
echo ""

# Save credentials to file
cat > /root/ukm-band-credentials.txt << EOF
UKM Band Deployment Credentials
================================
Website: https://$DOMAIN
phpMyAdmin: https://$DOMAIN/phpmyadmin

Database:
  Name: $DB_NAME
  User: $DB_USER
  Password: $DB_PASSWORD

App Directory: $APP_DIR
EOF

print_status "Credentials saved to /root/ukm-band-credentials.txt"
print_status "Caddy will automatically obtain SSL certificate for $DOMAIN"
print_warning "Make sure your DNS is pointing to this server!"
