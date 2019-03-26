require_relative 'config'

# usage:
#   say.rb          consume messages from queue
#   say.rb <words>  publish <words> to queue and monitor queue state

sqs = Aws::SQS::Client.new(region: TOPIC_REGION)

if ARGV.length > 0
  puts "Enqueuing #{ARGV.inspect}"

  ARGV.each_with_index do |word, idx|
    sqs.send_message({
      queue_url: QUEUE_URL,
      message_body: word
    })
    puts ARGV.length-idx
  end


  puts "Watching queue #{QUEUE_URL.inspect}"

  msgs_available = nil
  msgs_in_flight = nil

  loop do
    req = sqs.get_queue_attributes(
      {
        queue_url: QUEUE_URL, attribute_names:
          [
            'ApproximateNumberOfMessages',
            'ApproximateNumberOfMessagesNotVisible'
          ]
      }
    )

    msgs_available ||= req.attributes['ApproximateNumberOfMessages']
    msgs_in_flight ||= req.attributes['ApproximateNumberOfMessagesNotVisible']

    unchanged = false
    unchanged ||= msgs_available == req.attributes['ApproximateNumberOfMessages']
    unchanged ||= msgs_in_flight == req.attributes['ApproximateNumberOfMessagesNotVisible']

    unless unchanged
      puts 'Messages available: ' + msgs_available +  ', Messages in flight: ' + msgs_in_flight
    end

    msgs_available = req.attributes['ApproximateNumberOfMessages']
    msgs_in_flight = req.attributes['ApproximateNumberOfMessagesNotVisible']

    sleep(1)
  end
end


delay = 5
puts "Polling #{QUEUE_URL.inspect} every #{delay} seconds..."
loop do
  resp = sqs.receive_message(queue_url: QUEUE_URL, max_number_of_messages: 1)

  resp.messages.each do |m|
    puts m.body

    `#{SAY_CMD} #{m.body}`

    sqs.delete_message({
      queue_url: QUEUE_URL,
      receipt_handle: m.receipt_handle
    })

  end
  print '.'
  sleep(delay)
end
