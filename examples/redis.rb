# Here's how to start using log4r right away
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "/lib")
require "log4r"
require "log4r/logstash"
require "securerandom"

Log = Log4r::Logger.new("outofthebox")        # create a logger
Log.add Log4r::Outputter.stderr               # which logs to stdout

r = SecureRandom.uuid

additional_fields = {}
additional_fields["foo"] = "bar"
additional_fields["goo"] = "baz"
additional_fields["random"] = -> { r }

Log.add Log4r::Logstash::RedisOutputter.new("redis",
                                            data_field_name: "Message",
                                            level_field_name: "Level",
                                            additional_fields: additional_fields)

# do some logging
def do_logging
  Log.debug "debugging"
  Log.info "a piece of info"
  Log.warn "Danger, Will Robinson, danger!"
  Log.error "I dropped my Wookie! :("
  Log.fatal "kaboom!"
end
do_logging

# now let's filter anything below WARN level (DEBUG and INFO)
puts "-= Changing level to WARN =-"
Log.level = Log4r::WARN
do_logging
