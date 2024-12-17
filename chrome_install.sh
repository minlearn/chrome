###############

echo "Installing Dependencies"
apt-get install -y curl
apt-get install -y sudo
apt-get install -y mc
echo "Installed Dependencies"

echo "installing x11 supports"
apt-get install --no-install-recommends debconf-utils -y -qq >/dev/null 2>&1
echo keyboard-configuration  keyboard-configuration/unsupported_config_options       boolean true | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/switch   select  No temporary switch | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/unsupported_config_layout        boolean true | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/layoutcode       string  us | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/compose  select  No compose key | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/modelcode        string  pc105 | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/unsupported_options      boolean true | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/variant  select  English \(US\) | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/unsupported_layout       boolean true | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/model    select  Generic 105-key PC \(intl.\) | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/ctrl_alt_bksp    boolean false | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/layout   select | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/toggle   select  No toggling | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/variantcode      string | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/altgr    select  The default for the keyboard layout | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/xkb-keymap       select  us | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/optionscode      string | debconf-set-selections >/dev/null 2>&1; \
echo keyboard-configuration  keyboard-configuration/store_defaults_in_debconf_db     boolean true | debconf-set-selections >/dev/null 2>&1

apt-get install --no-install-recommends keyboard-configuration xserver-xorg xinit xterm libgtk-3-0 libwebkit2gtk-4.0-37 -y -qq >/dev/null 2>&1

chmod u+s /usr/lib/xorg/Xorg
touch /home/tdl/.Xauthority /root/.Xauthority

cat >/usr/lib/systemd/system/xorg.service<<EOF
[Unit]
Description=X-Window

[Service]
Type=simple
ExecStart=/bin/su --login tdl -c "/usr/bin/startx -- :10 vt1 -ac -nolisten tcp"
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

echo 'exec xterm' > /root/.xinitrc;
echo 'exec xterm' > /home/tdl/.xinitrc;
systemctl enable -q --now xorg.service

echo "install chrome"
apt-get install gnupg -y
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install google-chrome-stable fonts-wqy-zenhei -y
apt-get install xrdp -y


echo "Cleaning up"
apt-get -y autoremove
apt-get -y autoclean
echo "Cleaned"

##############