resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/ecs"
  retention_in_days = 180
}