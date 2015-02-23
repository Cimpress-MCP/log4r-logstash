# log4r-logstash

log4r-logstash allows you to send Log4r logevents to Logstash with json encoding.
It currently only supports a redis transport, but could easily be extended to other
transports based on need.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'log4r-logstash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install log4r-logstash

## Usage

```ruby
Log = Log4r::Logger.new("outofthebox")        # create a logger
Log.add Log4r::Logstash::RedisOutputter.new("redis")
Log.debug("test")
# : Sends the following json to 127.0.0.1:6379
# {
#   "type":"Log4r::LogEvent",
#   "index":"logstash",
#   "level":"DEBUG",
#   "data":"test",
#   "timestamp":"2015-01-27T19:44:29Z"
# }
```
Send to redis running on another host

```ruby
Log.add Log4r::Logstash::RedisOutputter.new("redis", host: "myredisserver.mydomain.com")
```

Specify an index name
```ruby
Log.add Log4r::Logstash::RedisOutputter.new("redis", index: "my_index")
```

You can override many of the default field names to match your conventions

```ruby
Log.add Log4r::Logstash::RedisOutputter.new("redis",
                                            level_field_name: "LEVEL"
                                            data_field_name: "MESSAGE")
# {
#   "type":"Log4r::LogEvent",
#   "index":"logstash",
#   "LEVEL":"DEBUG",
#   "MESSAGE":"test",
# }
```

Add extra fields as necessary for your application. These will be passed straight
through in the json as top level key-value pairs.

```ruby
Log.add Log4r::Logstash::RedisOutputter.new("redis", additional_fields: {
                                                       foo: "bar",
                                                       goo: "baz"
                                                       time: -> { Time.now.getutc.rfc822 }
                                                     })
# {
#   "type":"Log4r::LogEvent",
#   "index":"logstash",
#   "level":"DEBUG",
#   "data":"test",
#   "timestamp":"2015-01-27T19:44:29Z"
#   "foo":"bar"
#   "goo":"baz"
#   "time":"Wed, 27 Jan 2015 19:44:29 -000"
# }
```

## Contributing

1. Fork it ( https://github.com/Cimpress-MCP/log4r-logstash/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

You can spin up a local redis instance in virtualbox  using the included Vagrantfile
by typing `vagrant up`. Monitor incoming messages using `vagrant ssh -c "redis-cli monitor"`.

Run a simple example with `ruby examples/redis.rb`
