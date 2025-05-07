#!/bin/bash
set -euo pipefail

# === Load only required variables from .env ===
if [ ! -f .env ]; then
  echo "❌ Missing .env file. Aborting."
  exit 1
fi

# Extract required variables
GROUP_NAME=$(grep -E '^GROUP_NAME=' .env | cut -d '=' -f2-)
TARGET_USER=$(grep -E '^TARGET_USER=' .env | cut -d '=' -f2-)
JENKINS_USER=$(grep -E '^JENKINS_USER=' .env | cut -d '=' -f2-)
TARGET_DIR=$(grep -E '^TARGET_DIR=' .env | cut -d '=' -f2-)

# Validate
: "${GROUP_NAME:?GROUP_NAME not set}"
: "${TARGET_USER:?TARGET_USER not set}"
: "${JENKINS_USER:?JENKINS_USER not set}"
: "${TARGET_DIR:?TARGET_DIR not set}"

echo "🔧 Using:
  GROUP_NAME=$GROUP_NAME
  TARGET_USER=$TARGET_USER
  JENKINS_USER=$JENKINS_USER
  TARGET_DIR=$TARGET_DIR"

# === Group Creation ===
if ! getent group "$GROUP_NAME" > /dev/null 2>&1; then
    echo "➕ Creating group $GROUP_NAME"
    sudo groupadd "$GROUP_NAME"
else
    echo "✅ Group $GROUP_NAME already exists"
fi

# === Add Users to Group ===
echo "👥 Adding users to group..."
sudo usermod -aG "$GROUP_NAME" "$TARGET_USER"
sudo usermod -aG "$GROUP_NAME" "$JENKINS_USER"

# === Update Directory Ownership & Permissions ===
echo "🔒 Setting directory ownership and permissions..."
sudo chown -R "$TARGET_USER":"$GROUP_NAME" "$TARGET_DIR"
sudo chmod -R 2770 "$TARGET_DIR"
sudo find "$TARGET_DIR" -type d -exec chmod g+s {} +

# === Create & Fix Jenkins Temp Dir ===
TMP_DIR="$TARGET_DIR/@tmp"
echo "🛠️ Ensuring Jenkins temp dir exists at $TMP_DIR"
sudo mkdir -p "$TMP_DIR"
sudo chown -R "$JENKINS_USER":"$GROUP_NAME" "$TMP_DIR"
sudo chmod -R 770 "$TMP_DIR"

echo "✅ Permissions and group setup complete for Jenkins on $TARGET_DIR"
