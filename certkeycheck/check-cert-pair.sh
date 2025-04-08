#!/bin/bash

# sudo nano ~/docker/traefik/check-cert-pair.sh
# sudo chmod +x ~/docker/traefik/check-cert-pair.sh
# sudo ~/docker/traefik/check-cert-pair.sh

TIMEOUT=5

# ✅ Root check & sudo prompt
if [[ "$EUID" -ne 0 ]]; then
  echo "🔐 This script needs to run as root."
  echo "📥 Attempting to elevate using sudo..."
  exec sudo "$0" "$@"
fi

echo "🔒 Certificate & Key Validation Script"
echo ""
echo "📁 Current directory: $(pwd)"
echo ""
echo "📦 Default certificate path: ./certs/fullchain.pem"
echo "🔑 Default key path:         ./certs/privkey.pem"
echo ""
echo "⌛ Press Enter within $TIMEOUT seconds to use the default values."
echo ""

# Prompt with timeout and fallback
read -t $TIMEOUT -p "📝 Enter path to certificate file [./certs/fullchain.pem]: " CERT_FILE
CERT_FILE=${CERT_FILE:-./certs/fullchain.pem}

read -t $TIMEOUT -p "🔑 Enter path to private key file [./certs/privkey.pem]: " KEY_FILE
KEY_FILE=${KEY_FILE:-./certs/privkey.pem}

# Check existence
if [[ ! -f "$CERT_FILE" ]]; then
    echo -e "\n❌ Certificate file not found: $CERT_FILE\n"
    exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
    echo -e "\n❌ Private key file not found: $KEY_FILE\n"
    exit 1
fi

# 🔍 Validate certificate format
if ! openssl x509 -in "$CERT_FILE" -noout > /dev/null 2>&1; then
    echo -e "\n❌ Invalid certificate format in: $CERT_FILE\n"
    exit 1
fi

# 🔍 Validate key format
if ! openssl rsa -in "$KEY_FILE" -check -noout > /dev/null 2>&1; then
    echo -e "\n❌ Invalid RSA private key format in: $KEY_FILE\n"
    exit 1
fi

# 🔐 Match cert and key
CERT_MODULUS=$(openssl x509 -noout -modulus -in "$CERT_FILE" | openssl md5)
KEY_MODULUS=$(openssl rsa -noout -modulus -in "$KEY_FILE" | openssl md5)

if [[ "$CERT_MODULUS" != "$KEY_MODULUS" ]]; then
    echo -e "\n❌ Certificate and key do NOT match!\n"
    exit 1
else
    echo -e "\n✅ Certificate and key match.\n"
fi

# 🔗 Check fullchain
CERT_DEPTH=$(grep -c "BEGIN CERTIFICATE" "$CERT_FILE")
echo "🔍 Certificate block count: $CERT_DEPTH"
if [[ "$CERT_DEPTH" -lt 2 ]]; then
    echo -e "⚠️  Only $CERT_DEPTH certificate block(s) found in $CERT_FILE."
    echo "💡 It may be missing intermediate certificates (not a full chain)."

    # Offer to fix if cert.pem and chain.pem are available
    CERT_DIR=$(dirname "$CERT_FILE")
    if [[ -f "$CERT_DIR/cert.pem" && -f "$CERT_DIR/chain.pem" ]]; then
        read -p "🔧 Do you want to regenerate fullchain.pem from cert.pem + chain.pem? (y/N): " fix_fullchain
        if [[ "$fix_fullchain" =~ ^[Yy]$ ]]; then
            echo -e "\n📝 Concatenating cert.pem and chain.pem to regenerate fullchain.pem..."
            cat "$CERT_DIR/cert.pem" "$CERT_DIR/chain.pem" > "$CERT_FILE"
            echo -e "\n✅ fullchain.pem regenerated."
        fi
    fi
else
    echo -e "✅ Certificate includes a full chain ($CERT_DEPTH certificate blocks).\n"
fi

# 🔐 Fix permissions
chmod 644 "$CERT_FILE"
chmod 600 "$KEY_FILE"
chown root:root "$CERT_FILE" "$KEY_FILE"

echo "🔐 Permissions set:"
ls -l "$CERT_FILE" "$KEY_FILE"
echo ""

# 🔁 Re-check final state
FINAL_DEPTH=$(grep -c "BEGIN CERTIFICATE" "$CERT_FILE")
echo "🔁 Final certificate block count: $FINAL_DEPTH"
echo "🔁 Verifying cert & key match one more time..."

FINAL_CERT_MODULUS=$(openssl x509 -noout -modulus -in "$CERT_FILE" | openssl md5)
FINAL_KEY_MODULUS=$(openssl rsa -noout -modulus -in "$KEY_FILE" | openssl md5)

if [[ "$FINAL_CERT_MODULUS" == "$FINAL_KEY_MODULUS" && "$FINAL_DEPTH" -ge 2 ]]; then
    echo -e "\n✅ Certificate is now valid, complete, and matches the key.\n"
else
    echo -e "\n❌ Something went wrong after regeneration or permission change."
    echo -e "  Please verify your certificate chain and key.\n"
    exit 1
fi

echo "🎉 All checks passed. Safe to use in Traefik!"
exit 0
