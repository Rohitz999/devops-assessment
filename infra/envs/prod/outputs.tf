output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "ecs_cluster" {
  value = module.ecs.cluster_id
}

output "database_password" {
  value     = random_password.db_password.result
  sensitive = true
}