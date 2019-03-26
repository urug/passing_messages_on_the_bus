Passing Message on the Bus: Message Buses on Ruby with AWS SNS, and SQS
------------------------------------------------

https://github.com/urug/passing_messages_on_the_bus

Examples and presentation showing the basic concepts of Message Busses and
how they compare to Message Queues, and how to implement them in Ruby using
Amazon Web Services Simple Notification Service (SNS) and Simple Queuing
Serivce (SQS)

# Setup instructions

`bundle install`

To execute the individual .rb files, use: `bundle exec ruby <file_name>`.

# Files included

Non-exhaustive list of the files in this repo:

* README.md - this file
* PRESENTATION.md - Presentation slides in markdown format for parsing with `pandoc`
* config.rb - contains AWS settings for example files
* create_subscription_for_topic.rb - Example of creating a subscription for a topic
* get_all_topics.rb - Example of getting a list of all topics
* get_subscriptions_for_topic.rb  - Example of getting all subscribers for a topic
* read_message_from_queue.rb - Example of reading a message from a queue
* read_message_from_queue_and_delete.rb - Example of reading a message from a queue and deleting it after
* send_message_to_topic.rb - Example of sending a message to a topic
* say.rb - Distributed example to show how messages busses and queues distribute work -- NOTE: currently only works on MacOS
* say_lorem.sh - Loads the `say.rb` message bus with Lorem Ipsum text.

# Presentation

The presentation (`PRESENTATION.md`) can be converted in to an HTML file with:

`pandoc PRESENTATION.md -t revealjs -o PRESENTATION.html --self-contained`

Requires [pandoc](https://pandoc.org) to be installed and [reveal.js](https://reveal.js) to be in the current directory.
