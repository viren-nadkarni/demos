#
#
#                  +-----------------------+
#                  |                       |
#                  |  Amazon SNS           |
#                  |  (Notification Topic) |
#                  |                       |
#                  +-----------+-----------+
#                              |
#                              |
#                              |
#                              v
#                  +-----------------------+
#                  |                       |
#                  |  Amazon SQS           |
#                  |  (Message Queue)      |
#                  |                       |
#                  +-----------------------+
#
#


# Create an SNS topic
resource "aws_sns_topic" "example_topic" {
  name = "example_topic"
}

# Create an SQS queue
resource "aws_sqs_queue" "example_queue" {
  name = "example_queue"
}

# Subscribe the SQS queue to the SNS topic
resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.example_queue.arn
}

output "sns_topic" {
  value = aws_sns_topic.example_topic.arn
}

output "sqs_queue" {
  value = aws_sqs_queue.example_queue.url
}
