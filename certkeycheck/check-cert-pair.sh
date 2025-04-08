#!/bin/bash

# sudo nano ~/docker/traefik/check-cert-pair.sh
# sudo chmod +x ~/docker/traefik/check-cert-pair.sh
# sudo ~/docker/traefik/check-cert-pair.sh

# ⏱ Default timeout for input (in seconds)
TIMEOUT=5

# ✅ Root check & sudo prompt
if [[ "$EUID" -ne 0 ]]; then
  echo "🔐 This script needs to run as root."
  echo "📥 Attempting to elevate using sudo..."
  exec sudo "$0" "$@"
fi

echo "🔒 Certificate & Key Validation Script"
echo "📁 Current directory: $(pwd)"
echo "📦 Default certificate path: ./certs/fullchain.crt"
echo "🔑 Default key path:         ./certs/privkey.key"
echo "⌛ Press Enter within $TIMEOUT seconds to use the default values."

# Prompt with timeout and fallback
read -t $TIMEOUT -p "📝 Enter path to certificate file [./certs/fullchain.crt]: " CERT_FILE
CERT_FILE=${CERT_FILE:-./certs/fullchain.crt}

read -t $TIMEOUT -p "🔑 Enter path to private key file [./certs/privkey.key]: " KEY_FILE
KEY_FILE=${KEY_FILE:-./certs/privkey.key}

# Check if files exist
if [[ ! -f "$CERT_FILE" ]]; then
    echo "❌ Certificate file not found: $CERT_FILE"
    exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
    echo "❌ Private key file not found: $KEY_FILE"
    exit 1
fi

# Check certificate format
if ! openssl x509 -in "$CERT_FILE" -noout > /dev/null 2>&1; then
    echo "❌ Invalid certificate format in: $CERT_FILE"
    exit 1
fi

# Check key format
if ! openssl rsa -in "$KEY_FILE" -check -noout > /dev/null 2>&1; then
    echo "❌ Invalid RSA private key format in: $KEY_FILE"
    exit 1
fi

# Match cert and key
CERT_MODULUS=$(openssl x509 -noout -modulus -in "$CERT_FILE" | openssl md5)
KEY_MODULUS=$(openssl rsa -noout -modulus -in "$KEY_FILE" | openssl md5)

if [[ "$CERT_MODULUS" != "$KEY_MODULUS" ]]; then
    echo "❌ Certificate and key do NOT match!"
    exit 1
else
    echo "✅ Certificate and key match."
fi

# Full chain check
CERT_DEPTH=$(grep -c "BEGIN CERTIFICATE" "$CERT_FILE")
if [[ "$CERT_DEPTH" -lt 2 ]]; then
    echo "⚠️  Certificate may not include full chain. ($CERT_DEPTH certificate block(s) found)"
    echo "   You may need to concatenate intermediate certs with your server cert."
else
    echo "✅ Certificate includes a full chain ($CERT_DEPTH certificate blocks)."
fi

# Fix permissions
chmod 644 "$CERT_FILE"
chmod 600 "$KEY_FILE"
chown root:root "$CERT_FILE" "$KEY_FILE"

echo "🔐 Permissions set:"
ls -l "$CERT_FILE" "$KEY_FILE"

echo "✅ All done!"

exit 0
