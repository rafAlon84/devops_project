output "private_subnet_id" {
  description = "Id from Private subnet"
  value       = module.vpc_cluster.private_subnets[0]
}

output "sg_worker_id" {
  description = "Id from worker sg"
  value       = module.sg_worker.security_group_id
}

output "sg_manager_id" {
  description = "Id from manager sg"
  value       = module.sg_manager.security_group_id
}

output "sg_alb_id" {
  description = "Id from alb sg"
  value       = module.alb_http_sg.security_group_id
}

