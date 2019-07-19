  resource "aws_sqs_queue" "shoryuken_1" {
    name                       = "${var.environment}_job_queue_shoryuken_1"
    delay_seconds              = 1
    max_message_size           = 262144   # 256 KiB
    message_retention_seconds  = 345600   # 4 days
    receive_wait_time_seconds  = 0
    visibility_timeout_seconds = 300      # 5 minutes

    tags = {
      Environment = "${var.environment}"
    }
  }
