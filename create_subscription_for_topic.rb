require_relative 'config'

sns = Aws::SNS::Resource.new(region: TOPIC_REGION)

topic = sns.topic(TOPIC_ARN)

sub = topic.subscribe({
  protocol: 'sqs',
  endpoint: QUEUE_ARN
})

puts sub.arn
