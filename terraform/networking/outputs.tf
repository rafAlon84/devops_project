output "private_subnet_id" {
  description = "Id from Private subnet"
  value       = module.vpc_cluster.private_subnet.id
}

output "sg_worker_id" {
  description = "Id from worker sg"
  value       = module.sg_worker.security_group_id
}

output "sg_manager_id" {
  description = "Id from manager sg"
  value       = module.sg_manager.security_group_id
}

