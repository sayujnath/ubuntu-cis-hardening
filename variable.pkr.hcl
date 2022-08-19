######################################################################
#
#   Title:          CIS Hardened Ubuntu AMI with Node.js
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Company:        Canditude
#   Description:   This is the list of input variables for file cisL1_hardened_ubuntu_ami.pkr.hcl 
#                   which achieves the following:
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

variable "aws_profile" {
  type =  string
}

# name of the base ami. This AMI needs to exist in the same region as
# the aws profile. 
#To look up Ubuntu AMIs for a specifc region and/or version
# please use : https://cloud-images.ubuntu.com/locator/ec2/
variable "base_ubuntu_ami" {
  type =  string
}


# A unique name of the newly minted AMI. If an AMI with this name
# already exists, the build will fail.
variable "ami_name" {
  type =  string
}

# To create a free account for ubntu advantage, please view:
# https://ubuntu.com/advantage
variable "ubuntu_advantage_key" {
  type =  string
  sensitive = true
}