require 'aws-sdk-sns'
require 'aws-sdk-sqs'

# user: passing-messages-on-the-bus
# Keys are obfuscated with simple cypher. Not a security risk because
# these keys will be deactivated after the presnetation.
ENC_AWS_KEY_ID = 'NXVNWA3RQI2QOWXUJHXN'
ENC_AWS_SECRET_KEY = 'XvxoWzmU8z5jUxGu1LDxfB87DFUGptxzdZnh4HV0'

TOPIC_REGION = 'us-west-2'.freeze
TOPIC_ARN = 'arn:aws:sns:us-west-2:311246316502:passing-messages-on-the-bus'.freeze
QUEUE_ARN = 'arn:aws:sqs:us-west-2:311246316502:passing-messages-on-the-bus'.freeze
QUEUE_URL = 'https://sqs.us-west-2.amazonaws.com/311246316502/passing-messages-on-the-bus'.freeze

SAY_CMD = '/usr/bin/say'.freeze

Aws.config.update({
  region: 'us-west-2',
  credentials: Aws::Credentials.new(
    ENC_AWS_KEY_ID.tr("A-Za-z", "N-ZA-Mn-za-m"),
    ENC_AWS_SECRET_KEY.tr("A-Za-z", "N-ZA-Mn-za-m")
  )
})
