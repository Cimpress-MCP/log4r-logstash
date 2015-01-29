require "log4r/logstash/version"

module Log4r
  module Logstash
    autoload :RedisOutputter, "log4r/logstash/outputter/redis_outputter.rb"
  end
end
