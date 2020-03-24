#Authentication to DO
#https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/
#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer APIKEY" "https://api.digitalocean.com/v2/droplets?page=1&per_page=1" | python -m json.tool

provider "digitalocean" {
  token = "DO-API-TOKEN"
}
#Create CS Team Server
resource "digitalocean_droplet" "creeper" {
  name     = "creeper"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "s-1vcpu-2gb"
  ssh_keys = [SSH_ID]

  #MV CS install to droplett
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt-get -y install git zip python3 chromium-chromedriver python3-pip",
      "git clone https://github.com/smicallef/spiderfoot.git /opt/spiderfoot",
      "cd /opt/spiderfoot",
      "pip3 install -r requirements.txt",
      "sleep 2",
      "cd ../",
      "wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip",
      "unzip aquatone_linux_amd64_1.7.0.zip -d /usr/bin/",
      "git clone https://github.com/aboul3la/Sublist3r.git /opt/sublist3r",
      "cd /opt/sublist3r",
      "pip3 install -r requirements.txt",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("/../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}
#Create FW
resource "digitalocean_firewall" "creeperfw" {
  name = "creeper-fw"

  droplet_ids = [digitalocean_droplet.creeper.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["OPERATOR_IP"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["OPERATOR_IP"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["OPERATOR_IP"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
