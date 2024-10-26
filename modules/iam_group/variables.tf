variable "group_names" {
  description = "List of group names"
  type        = list(string)
}

variable "group_users" {
  description = "Mapping of group names to lists of user names"
  type        = map(list(string))
}

# Políticas Gerenciadas (Managed Policies) - lista de ARNs para cada grupo
variable "managed_policies" {
  description = "Map of group names to list of managed policy ARNs"
  type        = map(list(string))
  default     = {}
}

# Políticas Inline - múltiplas políticas para cada grupo
variable "inline_policies" {
  description = "Map of group names to inline policies"
  type        = map(map(any))  # Mapa de grupo para política JSON
  default     = {}
}
