#API > Personal access tokens > Generate
#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer DOAPITOKEN" "https://api.digitalocean.com/v2/account/ke
#ys" > ssh.json
#cat ssh.json and note the ID for SSH-ID

provider "digitalocean" {
  token = "APITOKEN"
}
resource "digitalocean_droplet" "web" {
  name     = "tf-TEST-1"
  image    = "ubuntu-18-04-x64"
  region   = "nyc3"
  size     = "512mb"
  ssh_keys = [SSH-ID]
  provisioner "remote-exec" {
    inline = [
      "wget https://raw.githubusercontent.com/LibertyUnix/do/master/build.sh",
      "chmod +x build.sh",
      "./build.sh",
    ]
    connection {
      type        = "ssh"
      host        = "${self.ipv4_address}"
      private_key = "${file("id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}
