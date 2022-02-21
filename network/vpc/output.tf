output "id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = join(",", aws_subnet.public.*.id)
}

output "private_subnets" {
  value = join(",", aws_subnet.private.*.id)
}

output "private_dms_subnets" {
  value = join(",", aws_subnet.private_dms.*.id)
}

output "public_subnets_arn" {
  value = join(",", aws_subnet.public.*.arn)
}

output "private_subnets_arn" {
  value = join(",",aws_subnet.private.*.arn)
}

output "private_dms_subnets_arn" {
  value = join(",", aws_subnet.private_dms.*.arn)
}

