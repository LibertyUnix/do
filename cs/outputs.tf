output "outputs" {
  value = [
    "Teamserver IP is ${digitalocean_droplet.teamserver.ipv4_address}",
    "R1 IP is ${digitalocean_droplet.c2-rdr-1.ipv4_address}",
    "R2 IP is ${digitalocean_droplet.c2-rdr-2.ipv4_address}",
    "R3 IP is ${digitalocean_droplet.c2-rdr-3.ipv4_address}",
  ]
}
