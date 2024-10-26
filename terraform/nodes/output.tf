output "common_workers_id" {
  description = "Ids from common workers"
  value       = module.ec2_instance[*].id
}
