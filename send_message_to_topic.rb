require_relative 'config'

sns = Aws::SNS::Resource.new(region: TOPIC_REGION)

topic = sns.topic(TOPIC_ARN)

response = topic.publish({
  message: 'Hello!'
})

puts response
