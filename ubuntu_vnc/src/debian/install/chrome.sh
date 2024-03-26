#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Chromium Browser"
# apt-get install -y chromium-browser
# ln -sfn /usr/bin/chromium /usr/bin/chromium-browser
# apt-get clean -y

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb
rm -rf google-chrome-stable_current_amd64.deb
# ln -sfn /opt/google/chrome/chrome /usr/bin/chromium-browser
echo "/opt/google/chrome/chrome --no-sandbox --test-type --start-maximized --disable-gpu --disable-dev-shm-usage  --user-data-dir --window-position=0,0 --no-first-run --start-maximized --no-default-browser-check" > /usr/bin/chromium-browser.sh
chmod -R 777 /usr/bin/chromium-browser.sh
ln -sfn /usr/bin/chromium-browser.sh /usr/bin/chromium-browser
