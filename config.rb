require 'aws-sdk-sns'
require 'aws-sdk-sqs'

# user: passing-messages-on-the-bus
AWS_KEY_ID = 'AKIAJR6TTLBH65M6UXCA'
AWS_SECRET_KEY = '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'

TOPIC_REGION = 'us-west-2'.freeze
TOPIC_ARN = 'arn:aws:sns:us-west-2:311246316502:passing-messages-on-the-bus'.freeze
QUEUE_ARN = 'arn:aws:sqs:us-west-2:311246316502:passing-messages-on-the-bus'.freeze
QUEUE_URL = 'https://sqs.us-west-2.amazonaws.com/311246316502/passing-messages-on-the-bus'.freeze

SAY_CMD = '/usr/bin/say'.freeze

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(AWS_KEY_ID, AWS_SECRET_KEY)
})