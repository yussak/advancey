# パブリックバケット
resource "aws_s3_bucket" "public" {
  bucket = "advancey-public-bucket"
}
resource "aws_s3_bucket_acl" "public" {
  bucket = aws_s3_bucket.public.id
  acl    = "public-read"
}
# ログバケット
# resource "aws_s3_bucket" "alb_log" {
#   bucket = "advancey-alb-log-bucket"

#   lifecycle_rule {
#     enabled = true

#     expiration {
#       days = "180"
#     }
#   }
# }
