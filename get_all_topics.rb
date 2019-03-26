require_relative 'config'

sns = Aws::SNS::Resource.new(region: TOPIC_REGION)

sns.topics.each do |topic|
  puts topic.arn
end
