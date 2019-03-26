require_relative 'config'

sqs = Aws::SQS::Client.new(region: TOPIC_REGION)

resp = sqs.receive_message(queue_url: QUEUE_URL, max_number_of_messages: 10)

resp.messages.each do |m|
  puts m.body

  sqs.delete_message({
    queue_url: QUEUE_URL,
    receipt_handle: m.receipt_handle
  })
end

# {
#   "Type" : "Notification",
#   "MessageId" : "508680ba-9e61-5173-bf2d-d5b728adede2",
#   "TopicArn" : "arn:aws:sns:us-west-2:378761248346:thursday-training",
#   "Message" : "Hello!",
#   "Timestamp" : "2019-03-21T15:58:04.005Z",
#   "SignatureVersion" : "1",
#   "Signature" : "QEbq/h4umu4oTHU66Wf+223Igp5q1ODujekt2BrPj1N4gEB1ZiKhW/fGAzES/2uGbJOj01/KoQUtgk97V0Ny/weee/bLqoZvLy9tCl4pdlKdqrMEm8OjVSKMzwMDZxBS74AraHgMNFibLF9dfvL0NHfPn+OF6E0Ry0pG3SJ13W767Kb2RhOvOO2H2I0RfM/YnNIQK/2AEunJnEqaEOwBRYtRHLLJ1lKRKVuFcSsydfTb7RmVBQ7TMGfA+nlIBGMviTPM7r7SHgBapYJEqv7t3411hkTeBJvGSn/S2pmx3R7tf5l1pj+Qow0AzEBF3fCZ7B4lg9rtHkGRT1rKajImsg==",
#   "SigningCertURL" : "https://sns.us-west-2.amazonaws.com/SimpleNotificationService-6aad65c2f9911b05cd53efda11f913f9.pem",
#   "UnsubscribeURL" : "https://sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-west-2:378761248346:thursday-training:76c3f4da-1404-48eb-b89a-414050b43c88"
# }
