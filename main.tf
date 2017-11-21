variable "region" {
  default = "ams1"
}

provider "scaleway" {
    region = "${var.region}"
}

variable "ssh_key_file" {
  type    = "string"
  default = "~/.ssh/id_rsa"
}

variable "ssh_key_path" {
  type    = "string"
  default = "/root/.ssh/authorized_keys"
}

data "scaleway_image" "docker" {
  architecture = "arm64"
  name         = "Docker"
}

###############################################################################
# jump-box
###############################################################################
module "jumpbox" {
    source                              = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/jumpbox"
    name                                = "jumpbox"
    type                                = "ARM64-2GB"
    region                              = "${var.region}"
    image_id                            = "${data.scaleway_image.docker.id}"
    provisioner_ssh_private_key_data    = "${file("${var.ssh_key_file}")}"
    ssh_private_key_file                = "${path.root}/.ssh/id_rsa"
    local-init-script                   = "${path.root}/key-gen.sh"
}

output "jumpbox.id" {
  value = "${module.jumpbox.id}"
}

output "jumpbox.ip" {
  value = "${module.jumpbox.ip}"
}

###############################################################################
# node01 (Nomad server)
###############################################################################
module "node01" {
    source                = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/node"
    name                  = "node01"
    type                  = "ARM64-4GB"
    region                = "${var.region}"
    image_id              = "${data.scaleway_image.docker.id}"
    jumpbox               = "${module.jumpbox.id}"
    jumpbox_ip            = "${module.jumpbox.ip}"
    ssh_public_key_file   = "${path.root}/.ssh/id_rsa.pub"
    tinc_ip               = "192.168.1.101"
}

###############################################################################
# node02 (Nomad agent and etcd server)
###############################################################################
module "node02" {
    source                = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/node"
    name                  = "node02"
    type                  = "ARM64-4GB"
    region                = "${var.region}"
    image_id              = "${data.scaleway_image.docker.id}"
    jumpbox               = "${module.jumpbox.id}"
    jumpbox_ip            = "${module.jumpbox.ip}"
    ssh_public_key_file   = "${path.root}/.ssh/id_rsa.pub"
    tinc_ip               = "192.168.1.102"
}

###############################################################################
# node03 (Nomad agent and minion)
###############################################################################
module "node03" {
    source                = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/node"
    name                  = "node03"
    type                  = "ARM64-4GB"
    region                = "${var.region}"
    image_id              = "${data.scaleway_image.docker.id}"
    jumpbox               = "${module.jumpbox.id}"
    jumpbox_ip            = "${module.jumpbox.ip}"
    ssh_public_key_file   = "${path.root}/.ssh/id_rsa.pub"
    tinc_ip               = "192.168.1.103"
}

###############################################################################
# node04 (Nomad agent and minion)
###############################################################################
module "node04" {
    source                = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/node"
    name                  = "node04"
    type                  = "ARM64-4GB"
    region                = "${var.region}"
    image_id              = "${data.scaleway_image.docker.id}"
    jumpbox               = "${module.jumpbox.id}"
    jumpbox_ip            = "${module.jumpbox.ip}"
    ssh_public_key_file   = "${path.root}/.ssh/id_rsa.pub"
    tinc_ip               = "192.168.1.104"
}

###############################################################################
# node05 (Nomad agent and minion)
###############################################################################
module "node05" {
    source                = "github.com/TheNatureOfSoftware/kubernetes-on-nomad/examples/scaleway/node"
    name                  = "node05"
    type                  = "ARM64-4GB"
    region                = "${var.region}"
    image_id              = "${data.scaleway_image.docker.id}"
    jumpbox               = "${module.jumpbox.id}"
    jumpbox_ip            = "${module.jumpbox.ip}"
    ssh_public_key_file   = "${path.root}/.ssh/id_rsa.pub"
    tinc_ip               = "192.168.1.105"
}

output "node01.id" {
  value = "${module.node01.id}"
}
output "node02.id" {
  value = "${module.node02.id}"
}
output "node03.id" {
  value = "${module.node03.id}"
}
output "node04.id" {
  value = "${module.node04.id}"
}
output "node05.id" {
  value = "${module.node05.id}"
}
