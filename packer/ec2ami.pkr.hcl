packer {
    required_plugins {
        ansible = {
            version = ">=1.0.0"
            source = "github.com/hashicorp/ansible"
        }
        
        amazon = {
            version = ">= 1.2.8"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "manager" {
    ami_name      = "${var.ami_manager}-${local.timestamp}"
    instance_type = var.instance-type
    region        = var.aws_region
    source_ami_filter {
        filters = {
            name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
            root-device-type    = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["099720109477"]
    }
    ssh_username = var.username
}

source "amazon-ebs" "worker" {
    ami_name      = "${var.ami_worker}-${local.timestamp}"
    instance_type = var.instance-type
    region        = var.aws_region
    source_ami_filter {
        filters = {
            name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
            root-device-type    = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["099720109477"]
    }
    ssh_username = var.username
}

build {
    name ="Docker-Manager"
    sources = [
        "source.amazon-ebs.manager"
    ]

    provisioner "ansible" {
        playbook_file = "../ansible/playbook.yml"
    }

    provisioner "shell" {
        inline = ["sudo docker swarm init"]
    }
}

build {
    name ="Docker-Worker"
    sources = [
        "source.amazon-ebs.worker"
    ]

    provisioner "ansible" {
        playbook_file = "../ansible/playbook.yml"
    }
}