variable "requester_vpc_id" {
  description = "VPC ID of the requester"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID of the accepter"
  type        = string
}

variable "accepter_region" {
  description = "Region of the accepter VPC"
  type        = string
}

variable "requester_cidr" {
  description = "CIDR block of the requester VPC"
  type        = string
}

variable "accepter_cidr" {
  description = "CIDR block of the accepter VPC"
  type        = string
}

variable "requester_public_route_table_ids" {
  description = "List of requester public route table IDs"
  type        = list(string)
  default     = []
}

variable "requester_private_route_table_ids" {
  description = "List of requester private route table IDs"
  type        = list(string)
  default     = []
}

variable "accepter_public_route_table_ids" {
  description = "List of accepter public route table IDs"
  type        = list(string)
  default     = []
}

variable "accepter_private_route_table_ids" {
  description = "List of accepter private route table IDs"
  type        = list(string)
  default     = []
}

variable "enable_public_routes" {
  description = "Enable creation of routes for public route tables"
  type        = bool
  default     = true
}

variable "enable_private_routes" {
  description = "Enable creation of routes for private route tables"
  type        = bool
  default     = true
}
