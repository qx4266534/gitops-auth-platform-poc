variable "tenant_name" {
  description = "Naam van de tenant"
  type        = string
}

variable "department" {
  description = "Afdeling"
  type        = string
  default     = ""
}

variable "contact_email" {
  description = "Contact email"
  type        = string
  default     = ""
}

variable "namespaces" {
  description = "Lijst van namespaces met resource quotas"
  type = list(object({
    name = string
    resource_quota = optional(object({
      cpu    = string
      memory = string
      pods   = string
    }))
  }))
}

variable "owners" {
  description = "Lijst van K8s usernames met admin rol"
  type        = list(string)
  default     = []
}

variable "developers" {
  description = "Lijst van K8s usernames met edit rol"
  type        = list(string)
  default     = []
}

variable "pos" {
  description = "Lijst van K8s usernames met view rol"
  type        = list(string)
  default     = []
}
