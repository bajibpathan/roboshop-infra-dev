#### Security Groups ####
# Bastion Module
module "bastion" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
}

# VPN Module
module "vpn" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.vpn_sg_name
  sg_description = var.vpn_sg_description
  vpc_id         = local.vpc_id
}

# Frontend Modules
# Frontend
module "frontend" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = local.vpc_id
}
# Frontend alb
module "frontend_alb" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "frontend-alb"
  sg_description = "for frontend alb"
  vpc_id         = local.vpc_id
}

#Backend
#Backeend ALB
module "backend_alb" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = var.backend_alb_sg_name
  sg_description = var.backend_alb_sg_description
  vpc_id         = local.vpc_id
}

# Catalogue
module "catalogue" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "catalogue"
  sg_description = "Sg for catalogue"
  vpc_id         = local.vpc_id

}
# User
module "user" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "user"
  sg_description = "Sg for user"
  vpc_id         = local.vpc_id

}
# User
module "cart" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "cart"
  sg_description = "Sg for cart"
  vpc_id         = local.vpc_id

}
# User
module "shipping" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "shipping"
  sg_description = "Sg for shipping"
  vpc_id         = local.vpc_id

}
# Payment
module "payment" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "payment"
  sg_description = "Sg for payment"
  vpc_id         = local.vpc_id

}

# Databass
# mongodb
module "mongodb" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "mongodb"
  sg_description = "Sg for mongodb"
  vpc_id         = local.vpc_id
}

#mysql
module "mysql" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "mysql"
  sg_description = "Sg for mysql"
  vpc_id         = local.vpc_id
}

#redis
module "redis" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "redis"
  sg_description = "Sg for redis"
  vpc_id         = local.vpc_id
}

#rabbitmq
module "rabbitmq" {
  source      = "git::https://github.com/bajibpathan/terraform-aws-securitygroup.git?ref=main"
  project     = var.project
  environment = var.environment

  sg_name        = "rabbitmq"
  sg_description = "Sg for rabbitmq"
  vpc_id         = local.vpc_id
}


#### Security Group Rules ####

# Bastion
#bastion accepting connection from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}
#backeend accepting connection from bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

#backeend accepting connection from VPN to backend alb on port 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id        = module.backend_alb.sg_id
}

#VPN
#VPN ports 22, 443, 1194, 943
# SSH -22
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

#HTTPS -443
resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
#HTTPS -1194 (internal)
resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
#HTTPS -943 (internal)
resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

#Frontend
resource "aws_security_group_rule" "fronted_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "fronted_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "fronted_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}
# Frontend ALB
resource "aws_security_group_rule" "fronted_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}
resource "aws_security_group_rule" "fronted_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

# Backend SG Rules
# Catalogoue 
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.catalogue.sg_id
}
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}
resource "aws_security_group_rule" "catalogue_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}
resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.catalogue.sg_id
}

# User
resource "aws_security_group_rule" "user_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "user_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.user.sg_id
}

# Cart
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.cart.sg_id
}

# Shipping
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.shipping.sg_id
}

# Payment

resource "aws_security_group_rule" "payment_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.payment.sg_id
}


#MongoDB
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_ports_vpn)
  type                     = "ingress"
  from_port                = var.mongodb_ports_vpn[count.index]
  to_port                  = var.mongodb_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.mongodb.sg_id
}

#Redis
resource "aws_security_group_rule" "redis_vpn_ssh" {
  count = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}
resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.redis.sg_id
}

resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}
resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.rabbitmq.sg_id
}

