terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peering" {
  provider      = aws.requester
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_region   = var.accepter_region
  auto_accept   = false

  tags = {
    Name = "peering-${var.requester_vpc_id}-to-${var.accepter_vpc_id}"
  }
}

# VPC Peering Connection Accepter
resource "aws_vpc_peering_connection_accepter" "peering_acceptor" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  tags = {
    Name = "accept-${var.accepter_vpc_id}"
  }
}

# Routes for Requester VPC (Handles Public & Private)
resource "aws_route" "requester_routes" {
  for_each = {
    for rt in concat(
      var.enable_public_routes ? var.requester_public_route_table_ids : [],
      var.enable_private_routes ? var.requester_private_route_table_ids : []
    ) : rt => rt
  }

  provider                  = aws.requester
  route_table_id            = each.key
  destination_cidr_block    = var.accepter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Routes for Accepter VPC (Handles Public & Private)
resource "aws_route" "accepter_routes" {
  for_each = {
    for rt in concat(
      var.enable_public_routes ? var.accepter_public_route_table_ids : [],
      var.enable_private_routes ? var.accepter_private_route_table_ids : []
    ) : rt => rt
  }

  provider                  = aws.accepter
  route_table_id            = each.key
  destination_cidr_block    = var.requester_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering_acceptor.id
}
