resource "aws_ami_from_instance" "cp-ami123" {
  name               = "cp-ami123"
  source_instance_id = "i-01a657471bc1d4f49"
}

output "copied_ami_id" {
  value = aws_ami_from_instance.cp-ami.ami_id
}