% Passing Messages on the Bus:
  Messages Busses with Ruby on AWS SNS and SQS
% Matthew Nielsen
  https://github.com/urug/passing_messages_on_the_bus
% March 26, 2019

# Before we begin
## Audience Participation

To follow along, please go to:

```
https://github.com/urug/passing_messages_on_the_bus
```

..and clone/download the repo and follow instructions in README.md

# Message Bus

:::::::::::::: {.columns}
::: {.column width="40%"}

:::
::: {.column width="60%"}
```text

   _____________
 _/_|[][][][][] | - -
(      City Bus | - -
=--OO-------OO--=dwb
```

:::
::::::::::::::

# Message Bus

A Message Bus (or ["Message-oriented Middleware"](https://en.wikipedia.org/wiki/Message-oriented_middleware)
as Wikipedia calls it) is a way for one part of a distributed system to send a
message to all or some of the other parts of the system

# Message Bus

"Bus" means that it is a shared among all the users

:::::::::::::: {.columns}
::: {.column width="60%"}

Think "Universal Serial Bus", where all your USB devices are connected to the same port on the computer

:::
::: {.column width="40%"}
```text
   _   ,--()
  ( )-'-.------|>
   "     `--[]
```
:::
::::::::::::::


# Message Bus

## Topics

Messages on a single bus are divided in to `topics` so that consumers can get only the messages they want to see

# Topics

Think of a Topic as a television channel

:::::::::::::: {.columns}
::: {.column width="50%"}

You TV antenna is actually receiving *all* the available channels, but it is only showing you the one you want to watch right now

:::
::: {.column width="50%"}
```text
     _______________
    |,----------.  |\
    ||           |=| |
    ||          || | |
    ||       . _o| | | __
    |`-----------' |/ /~/
     ~~~~~~~~~~~~~~~ / /
                     ~~
```
:::
::::::::::::::

# Message Bus

## Messages

::: incremental

The data in a Message Bus Topic called a `Message`

Catchy name, huh?

:::

# Messages

::: incremental

"Publishers" push messages to a topic in to a Topic on the Bus

"Subscribers" read messages from a Topic on the Bus

:::

# Messages

When a `publisher` pushes a message, any "subscribers" that are watching that Topic will get a copy of the message

# Messages

Messages are not removed from the Topic until all subscribers have had the message delivered *at least once*

However, a Topic can be configured to keep messages even after all subscribers have been serviced in case a new subscriber is added and needs the historic information

# Message Bus vs Queue

# Message Bus vs Queue

What is the difference between a Message Bus and a Queue?

# Message Bus vs Queue

Messages in a queue have a one-to-one relationship with a `worker`

Messages on a bus have a one-to-many relationship with `subscribers`

# Message Bus vs Queue

# Queue

:::::::::::::: {.columns}
::: {.column width="70%"}
Think of message queue as a stack of notes

Each note describes a job to be done

A worker takes a note off the stack and no other worker can work on that note

:::
::: {.column width="30%"}
```text
   ___________
  /          /|
 / W O R K  / |
/__________// |
|-_-_-_-_-_| /|
|-_-_-_-_-_| /
|__________|/
```
:::
::::::::::::::


# Message Bus

:::::::::::::: {.columns}
::: {.column width="60%"}
Think of Message Bus like the text scrolling on the bottom of TV News

Each subscriber reads the same text and does something when it sees information that it thinks is important

:::
::: {.column width="40%"}
```text
     O         O
      \\     //
       \\   //
        \\ //
       /~~~~~\
,-------------------,
| ,---------------, |
| |               | |
| |               | |
| |               | |
| |WS..NEWS..NEWS.| |
| |_______________| |
|___________________|
|_______________dcau|
```
:::
::::::::::::::

# How They Work

# How They Work

## Vs webhooks

:::::::::::::: {.columns}
::: {.column width="50%"}
Classic webhook design where one source sends individual messages to many services

:::
::: {.column width="50%"}
```text
 Source -----> Service A
        \
         \---> Service B
          \
           \-> Service C
```
:::
::::::::::::::

# How They Work

## Message Bus

:::::::::::::: {.columns}
::: {.column width="50%"}
Simplified Message Bus where the Bus serves as the intermediary for the messages

:::
::: {.column width="50%"}
```text
Source
  |
  V
+---+
|   | -----> Service A
| B |
| U | -----> Service B
| S |
|   | -----> Service C
+---+
```
:::
::::::::::::::

# Benefits

::: incremental
* Communication from `source` to `service` is buffered
* Source can put as much info as it wants on the Bus
* Services can be added independent of source
* Services can consume additional messages independent of source
:::

# Drawbacks
::: incremental
* One more thing to manage
* Another level of latency
* Possible Multiple Delivery
* Possible Out-of-order Delivery
:::

# Challenges

# Multiple Delivery

As a generalization, a message bus will guarantee delivery to each subscriber *at least once*, but they may be delivered *more than once*.

---

### Multiple Delivery

```ruby
foo = FooModel.first
foo.update(value: foo.value + 1)
```

If the message is delivered twice (to the same subscriber or different subscribers that work in the same data set) then the value would be incremented *twice*.

Possible fixes include rejecting duplicate messages or using only referencing absolute values.

# Out-of-order Delivery

Most message busses will attempt to deliver messages in the order they were received, but this is not always guaranteed.

---

### Out-of-order Delivery

```ruby
# message 1
FooModel.first.update(value: 2)

# message 2
FooModel.first.update(value: 3)
```

If `message 2` is delivered before `message 1`, then the value will be incorrect.

Possible fixes include timestamps, sequences, and linked-IDs to hold a message until the correct time.

# Value by Reference

---

### Value by Reference

Instead of absolute values, consider using references

:::::::::::::: {.columns}
::: {.column width="40%"}

```ruby
book = Book.find(id)

book.update(
  number_sold: 2_129
)
```

:::
::: {.column width="60%"}

```ruby
book = Book.find(id)

current_number_sold = Service
  .get_current_number_sold(book.id)

book.update(
  number_sold: current_number_sold
)
```

:::
::::::::::::::

---

### Value by Reference

Possible pitfall

:::::::::::::: {.columns}
::: {.column width="50%"}

Given these messages

```ruby
# message 1
FooModel.first.update(value: 1)

# message 2
FooModel.first.update(value: 3)
```

:::
::: {.column width="50%"}

This will never be called

```ruby
if FooModel.first.value == 2
  # .. guess this will
  # never happen...
end
```
:::
::::::::::::::

---

# Idempotence

# Idempotence

Idempotence is the property of certain operations in computer science whereby they can be applied multiple times without changing the result beyond the initial application.

# Idempotence

A key requirement of a any message system (be it a queue or a bus) is that the result must be "deterministic": a given set of inputs must always result in the same output.

# Break for Questions

# AWS SNS and SQS

# AWS SNS and SQS

SNS and SQS work with each in different parts of the system

# AWS SNS and SQS

## AWS SNS

Simple Notification Service

# AWS SNS

Receives messages from publishers

Sends to subscribers

# AWS SNS

Subscriber can be:

::: nonincremental
- http or https URL
- Email address
- Amazon SQS Queue
- AWS Lambda Function
- Mobile Device
- SMS phone number
:::

# AWS SQS

Simple Queue Service

# AWS SQS

An SQS queue subscribes to a given SNS Topic

SNS sends messages to that queue

Workers take messages out of the queue and work on them

# AWS SQS

```text

                 AWS         AWS
Publisher ---->  SNS  ---->  SQS  ----> Worker
                Topic       Queue

```

# Practicum
## Create a Topic
## Create a Queue
## Subscribe the Queue to the Topic

# Practicum
## Send message to topic
## Consume message from queue
## Delete message from queue

# AWS Specifics

# AWS Specifics
## Deleting Messages

SQS messages must be explicitly deleted, it does not happen automatically.

# AWS Specifics
## In-Flight messages

SQS messages are "in-flight" after they are pulled from the queue.

They are invisible to other consumers during this time.

After 30 seconds, they will be requeued if not deleted.

# Fun Stuff

If you have checked out the code and are on MacOS, run:

```shell
$ bundle exec ruby say.rb
```

..and turn up your volume!

# Credits

* City Bus Art by Donovan Bake: https://www.asciiart.eu/vehicles/busses
* USB Symbol: http://ascii.co.uk/art/usb
* TV by Ojoshiro: http://ascii.co.uk/art/tv
* TV by Daniel C. Au: https://www.asciiart.eu/electronics/televisions
