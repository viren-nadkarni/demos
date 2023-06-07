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

# Create an IAM policy allowing SNS to send messages to SQS
data "aws_iam_policy_document" "example_policy" {
  statement {
    sid    = "Example"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.example_queue.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.example_topic.arn]
    }
  }
}

# Attach the IAM policy
resource "aws_sqs_queue_policy" "example_queue_policy" {
  queue_url = aws_sqs_queue.example_queue.id
  policy    = data.aws_iam_policy_document.example_policy.json
}

output "sns_topic" {
  value = aws_sns_topic.example_topic.arn
}

output "sqs_queue" {
  value = aws_sqs_queue.example_queue.url
}
