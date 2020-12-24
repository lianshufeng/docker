#!/bin/bash

echo "Install Chromium Browser"

# install chrome
yum install -y $Chrome_URL 


echo "/usr/bin/google-chrome --no-sandbox --start-maximized --user-data-dir" > /usr/bin/chromium-browser
chmod -R 777 /usr/bin/chromium-browser


