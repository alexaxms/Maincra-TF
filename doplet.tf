resource "digitalocean_droplet" "maincra" {
  image = "ubuntu-18-04-x64"
  name = "maincra"
  region = "nyc3"
  size = "s-1vcpu-2gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "apt -y install docker.io",
      "docker run -d -p 25565:25565 --name mc -e EULA=TRUE -e ONLINE_MODE=FALSE itzg/minecraft-server"
    ]
  }
}