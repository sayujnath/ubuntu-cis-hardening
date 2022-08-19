######################################################################
#
#   Title:          CIS Hardened Ubuntu AMI with Node.js
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Company:        Canditude
#   Description:   This file does the following:
#                   1. Builds an AWS AMI with Ubuntu
#                   2. CIS Level 1 hardening of OS
#                   3. Installs AWS CLI v2
#                   4.Installs node.js using nvm
#                   5. Installs PM2 for production grade application service management
#
#                   This version of the code is untested and specially released 
#                   for non-commecial public consumption. For a production ready release,
#                   please contact the author at info@canditude.com
#
######################################################################


source "amazon-ebs" "aws_ebs" {
  ami_name      = var.ami_name
  encrypt_boot  = true
  instance_type = "t2.micro"
  profile        = var.aws_profile
  source_ami    = var.ubtunu_base_ami
  ssh_username  = "ubuntu"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.amazon-ebs.aws_ebs"]

  provisioner "shell" {
    inline = ["set -x",
            # Prevents interactive dialogs
            "sudo sed -i 's!# conf_force_conffold=YES!conf_force_conffold=YES!g' /etc/ucf.conf",
            "sudo apt-get update -yq",
            "sudo apt-get upgrade -yq",
            "sudo apt-get install ubuntu-advantage-tools",
            "sudo ua attach ${var.ubuntu_advantage_key}",
            "sudo ua enable cis",
            "sudo ua status",
            "cd /usr/share/ubuntu-scap-security-guides/cis-hardening",
            "sudo ./Canonical_Ubuntu_20.04_CIS-harden.sh lvl1_server",
            "sudo cis-audit level1_server",
            "echo \"Installing aws cli v2....\"",
            "cd /home/ubuntu/downloads",
            "sudo apt-get install zip unzip -y",
            "sudo curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
            "sudo unzip awscliv2.zip",
            "sudo ./aws/install",
            "sudo aws --version",
            "sudo /usr/local/aws-cli/v2/current/bin/aws --version",
            "sudo apt-get install jq -y",
            "sudo chmod 755 -R /usr/local",
            "echo \"Downloading latest Ruby Agent required for codedeploy...\"",
            "sudo apt-get install ruby-full -y",
            "sudo apt-get install wget -y",
            "sudo chmod -R 755 /var/log",
            "curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash",
            "echo \"Installing nvm and node with typescript....\"",
            "export NVM_DIR=\"$HOME/.nvm\"",
            "sudo chmod -R 755 $NVM_DIR",
            "set -x",
            "\\. \"$NVM_DIR/nvm.sh\"",
            "\\. \"$NVM_DIR/bash_completion\"",
            "echo $NVM_DIR",
            "ls -l $NVM_DIR",
            "nvm install 16.13.2",
            "nvm alias default node",
            "npm install -g typescript",
            "npm install -g ts-node",
            "echo \"Installing pm2 ....\"",
            "npm install pm2 -g && pm2 update"]
  }

}
