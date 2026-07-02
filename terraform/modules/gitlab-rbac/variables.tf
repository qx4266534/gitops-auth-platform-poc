variable "tenant_name" {
  description = "Naam van de tenant (GitLab group path)"
  type        = string
}

variable "display_name" {
  description = "Weergavenaam van de tenant"
  type        = string
}

variable "projects" {
  description = "Lijst van projecten met sub-projecten"
  type = list(object({
    name        = string
    sub_projects = list(string)
  }))
  default = []
}

variable "owners" {
  description = "Lijst van GitLab user IDs met Owner rol"
  type        = list(string)
  default     = []
}

variable "developers" {
  description = "Lijst van GitLab user IDs met Developer rol"
  type        = list(string)
  default     = []
}

variable "pos" {
  description = "Lijst van GitLab user IDs met Planner rol"
  type        = list(string)
  default     = []
}
