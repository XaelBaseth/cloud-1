variable "resource_group_name" {
  type        = string
  description = "Nom du groupe de ressources"
}

variable "location" {
  type        = string
  description = "Région Azure"
  default     = "westeurope"
}

variable "vm_name" {
  type        = string
  description = "Nom de la machine virtuelle"
}

variable "admin_username" {
  type        = string
  description = "Nom d'utilisateur SSH"
}

variable "admin_ssh_key_path" {
  type        = string
  description = "Chemin vers la clé publique SSH"
  default     = "~/.ssh/id_rsa.pub"
}
