echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
gpg --keyserver pgpkeys.mit.edu --recv-key  ED444FF07D8D0BF6
gpg -a --export ED444FF07D8D0BF6 | sudo apt-key add -
apt-get -y update
apt-get -y dist-upgrade
sleep 5
#!/bin/bash
echo "SYSTEM UPDATE"
export DEBIAN_FRONTEND=noninteractive
add-apt-repository universe
sleep 5
apt-get -y update
sleep 30
apt-get -y upgrade 
sleep 30
apt-get install -y expect
useradd libertyunix -p password
usermod -aG admin libertyunix 
usermod -aG sudo libertyunix
yes | bash /root/gui.sh
