output "rds_endpoint" {

  value = module.rds.db_endpoint

}

output "database_password" {

  value = random_password.db_password.result

  sensitive = true

}