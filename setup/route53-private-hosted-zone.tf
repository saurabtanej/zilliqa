resource "aws_route53_zone" "private" {
  name = "private.zilliqa.co"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}