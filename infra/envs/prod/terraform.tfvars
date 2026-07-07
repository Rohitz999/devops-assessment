aws_region = "us-east-1"

project_name = "hotel-booking"

environment = "prod"

vpc_cidr = "10.1.0.0/16"

public_subnets = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnets = [
  "10.1.11.0/24",
  "10.1.12.0/24"
]

availability_zones = [
  "us-east-1a",
  "us-east-1b"
]

desired_count = 2

db_instance_class = "db.t3.small"

backup_retention = 30

deletion_protection = true

db_name = "hoteldb"

db_username = "postgres"