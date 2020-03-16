variable "location" {
  type    = string
  default = "eastus2"
}

variable "naming_prefixes" {
  type    = list(string)
  default = ["eventstore"]
}

variable "eventstore_nodes" {
  type    = number
  default = 3
}

variable "eventstore_vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
