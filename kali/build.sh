echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
apt-get -y update
apt-get -y dist-upgrade
sleep 5
#install XFCE
echo "install xfce"
apt-get install -y kali-defaults kali-root-login desktop-base xfce4 xfce4-places-plugin xfce4-goodies

echo "vncserver check"
#vncserver check
dpkg -s "tightvncserver"|grep "Status: install ok installed" > /dev/null 2>&1
if [[ $? == 1 ]]
        then
                apt install tightvncserver -y
        else
                echo "Already installed"
fi

#vncserver setup
echo "run vncserver"
mkdir /root/.vnc
touch /root/.Xauthority
echo password | vncpasswd -f > /root/.vnc/passwd
chown -R root:root /root/.vnc
chmod 0600 /root/.vnc/passwd
vncserver

#firewall rule
echo "opening firewall for vnc connect"
ufw allow 5901/tcp

#make systemd file
echo "startup script"
cat <<EOF > /etc/systemd/system/vncserver@.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target
[Service]
Type=forking
User=root
PAMName=login
PIDFile=/root/.vnc/%H:%i.pid
ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1280x800 :%i
ExecStop=/usr/bin/vncserver -kill :%i
[Install]
WantedBy=multi-user.target
EOF
chmod 755 /etc/systemd/system/vncserver@.service
systemctl daemon-reload && systemctl enable vncserver@1.service
sleep 15
exit
