#Authentication to DO
#https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/
#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer APIKEY" "https://api.digitalocean.com/v2/droplets?page=1&per_page=1" | python -m json.tool

provider "digitalocean" {
  token = "DO-API-TOKEN"
}
#Create CS Team Server
resource "digitalocean_droplet" "teamserver" {
  name     = "teamserver"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "s-2vcpu-2gb"
  ssh_keys = [SSH_ID]

  #MV CS install to droplett
  provisioner "file" {
    source      = "cobaltstrike"
    destination = "/opt"

    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("../../dev/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
  provisioner "file" {
    source      = "file.txt"
    destination = "/opt/cobaltstrike/file.txt"

    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("/../../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt-get -y install git python3-pip default-jre",
      "cd /opt/cobaltstrike",
      "chmod +x update",
      "chmod +x cobaltstrike",
      "chmod +x teamserver",
      "git clone https://github.com/LibertyUnix/C2concealer.git",
      "cd C2concealer",
      "pip3 install -e .",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("../../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}
#Create FW
resource "digitalocean_firewall" "teamserverfw" {
  name = "teamserver-fw"

  droplet_ids = [digitalocean_droplet.teamserver.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["YOUR_IP"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
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
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
#Create Redirectors
resource "digitalocean_droplet" "c2-rdr-1" {
  name     = "c2-rdr"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [SSH_KEY]

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt-get -y install socat",
      "echo @reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:80 >> /etc/cron.d/mdadm",
      "echo @reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:443 >> /etc/cron.d/mdadm",
      "shutdown -r",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("../../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}

resource "digitalocean_droplet" "c2-rdr-2" {
  name     = "c2-rdr-2"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [SSH_ID]

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt-get -y install socat",
      "echo @reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:80 >> /etc/cron.d/mdadm",
      "echo @reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:443 >> /etc/cron.d/mdadm",
      "shutdown -r",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}

resource "digitalocean_droplet" "c2-rdr-3" {
  name     = "c2-rdr-3"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [SSH_ID]

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt-get -y install socat",
      "echo @reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:80 >> /etc/cron.d/mdadm",
      "echo @reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.teamserver.ipv4_address}:443 >> /etc/cron.d/mdadm",
      "shutdown -r",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("/../../../id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}
