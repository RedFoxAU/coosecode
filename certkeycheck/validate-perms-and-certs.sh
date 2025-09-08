#!/bin/bash
# validate-perms-and-certs.sh
# Ensures correct permissions and validates certs vs key

set -e

FILES=("cert.pem" "chain.pem" "fullchain.pem" "privkey.pem")
READY=true

echo "🔧 Setting permissions..."
for f in "${FILES[@]}"; do
  if [[ -f "$f" ]]; then
    if [[ "$f" == "privkey.pem" ]]; then
      chmod 600 "$f"
      echo "   $f → 600 (owner read/write only)"
    else
      chmod 644 "$f"
      echo "   $f → 644 (world-readable certs)"
    fi
  else
    echo "   ⚠️ $f not found"
    READY=false
  fi
done

CERT="fullchain.pem"
KEY="privkey.pem"

if [[ ! -f "$CERT" || ! -f "$KEY" ]]; then
  echo "❌ $CERT or $KEY missing, cannot validate"
  READY=false
else
  echo
  echo "🔎 Checking cert/key type..."
  CERT_TYPE=$(openssl x509 -in "$CERT" -noout -text | grep "Public Key Algorithm" | head -1)
  KEY_TYPE=$(openssl pkey -in "$KEY" -noout -text 2>/dev/null | grep "Private-Key" | head -1)

  echo "   Cert: $CERT_TYPE"
  echo "   Key : $KEY_TYPE"

  echo
  echo "🔎 Checking modulus (RSA) or public key match (EC)..."
  if echo "$CERT_TYPE" | grep -qi RSA; then
    CERT_MOD=$(openssl x509 -noout -modulus -in "$CERT" | openssl md5)
    KEY_MOD=$(openssl rsa -noout -modulus -in "$KEY" | openssl md5)
  elif echo "$CERT_TYPE" | grep -qi "id-ecPublicKey"; then
    CERT_PUB=$(openssl x509 -in "$CERT" -pubkey -noout)
    KEY_PUB=$(openssl pkey -in "$KEY" -pubout)
    CERT_MOD=$(echo "$CERT_PUB" | openssl md5)
    KEY_MOD=$(echo "$KEY_PUB" | openssl md5)
  else
    echo "❌ Unknown key algorithm"
    READY=false
  fi

  if [[ "$CERT_MOD" == "$KEY_MOD" ]]; then
    echo "✅ Certificate and key match"
  else
    echo "❌ Certificate and key DO NOT match"
    READY=false
  fi

  echo
  echo "🔎 Checking certificate expiration..."
  if ! openssl x509 -in "$CERT" -noout -dates; then
    READY=false
  fi

  echo
  echo "🔎 Verifying full certificate chain..."
  if openssl verify -CAfile "$CERT" "$CERT"; then
    echo "   ✅ Chain verification OK"
  else
    echo "   ❌ Chain verification failed"
    READY=false
  fi
fi

echo
if $READY; then
  echo "✅ READY"
  exit 0
else
  echo "❌ NOT READY"
  exit 1
fi
