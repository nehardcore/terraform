###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
# variable "default_cidr" {
#   type        = list(string)
#   default     = ["10.0.1.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "vpc_name" {
#   type        = string
#   default     = "develop"
#   description = "VPC network&subnet name"
# }

###common vars

variable "vms_ssh_root_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

# ###example vm_web var
# variable "vm_web_name" {
#   type        = string
#   default     = "netology-develop-platform-web"
#   description = "example vm_web_ prefix"
# }

# ###example vm_db var
# variable "vm_db_name" {
#   type        = string
#   default     = "netology-develop-platform-db"
#   description = "example vm_db_ prefix"
# }

variable "vm_local_ip" {
  type = string
  default = "10.0.1.4"
  validation {
    condition     = can(cidrnetmask("${var.vm_local_ip}/32"))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

# variable "vm_local_ips" {
#   type = list(string)
#   default = ["10.0.1.4", "192.168.0.4", "127.0.0.1"]
#   validation {
#     condition = alltrue([
#       for a in var.vm_local_ips : can(cidrnetmask("${a}/32"))
#     ])
#     error_message = "All elements must be valid IPv4 CIDR block addresses."
#   }
# }