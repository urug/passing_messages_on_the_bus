require_relative 'config'

sns = Aws::SNS::Resource.new(region: TOPIC_REGION)

topic = sns.topic(TOPIC_ARN)

topic.subscriptions.each do |s|
  puts s.attributes['Endpoint']
end
