module "http_sg" {
  source      = "./security_group"
  name        = "http_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  cidr_blocks = ["0.0.0.0/0"]
}

module "https_sg" {
  source      = "./security_group"
  name        = "https_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 443
  cidr_blocks = ["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source      = "./security_group"
  name        = "http_redirect_sg"
  vpc_id      = aws_vpc.vpc.id
  port        = 8080
  cidr_blocks = ["0.0.0.0/0"]
}
