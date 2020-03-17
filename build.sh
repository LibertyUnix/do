echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
apt-get -y update
apt-get -y --allow-unauthenticated install kali-archive-keyring
apt-get -y update
apt-get -y install kali-linux-all
