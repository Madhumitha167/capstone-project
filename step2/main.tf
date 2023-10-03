data "terraform_remote_state" "step1" {
  backend = "local"
  config = {
    path = "../step1/terraform.tfstate"  # Path to the state file of step1
  }
}

resource "aws_ami_from_instance" "CAPSTONE" {
  name               = "CAPSTONE"
  source_instance_id = data.terraform_remote_state.step1.outputs.instance_id
}

output "ami_id" {
  value = aws_ami_from_instance.CAPSTONE.id
}