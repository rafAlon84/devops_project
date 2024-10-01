packer {
    required_plugins {
        ansible = {
            version = "~> 1"
            source = "github.com/hashicorp/ansible"
        }
        
        amazon = {
            version = ">= 1.2.8"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "docker" {
    ami_name      = "${var.ami_docker}-${local.timestamp}"
    instance_type = var.instance_type
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
    ssh_username = "ubuntu"
}


build {
    name ="Docker-Cluster"
    sources = [
        "source.amazon-ebs.docker"
    ]

    provisioner "shell" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install python3-pip -y",
            "sudo -H pip3 install ansible"
        ]
    }

    provisioner "ansible-local" {
        playbook_file = "./playbook.yml"
        // user = "ubuntu"
        // "For debug mode uncomment extra_arguments"
        // extra_arguments   = [ 
        //     "-vvvv",
        // ]  
        // ansible_env_vars = [ "ANSIBLE_SSH_ARGS='-o ControlPersist=600s'" ]
    }
}
