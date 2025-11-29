data "digitalocean_project" "devops" {
  name = "devops"
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  image    = "ubuntu-24-04-x64"
  name     = "jenkins-server"
  region   = "syd1"
  size     = "s-2vcpu-4gb"
  backups  = false
  ssh_keys = [50340717]
}

resource "digitalocean_project_resources" "devops_project_resources" {
  project = data.digitalocean_project.devops.id
  resources = [
    digitalocean_droplet.web.urn
  ]
}
