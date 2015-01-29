require "log4r/outputter/outputter"
require "redis"
require "retryable"

require_relative "../formatter/json_formatter"

module Log4r
  module Logstash
    class RedisOutputter < Log4r::Outputter
      def initialize(name, hash = {})
        super(name, hash)

        @index = hash[:index] || "logstash"
        @additional_fields = hash[:additional_fields] || {}
        @data_field_name = hash[:data_field_name] || "data"
        @level_field_name = hash[:level_field_name] || "level"
        @timestamp_field_name = hash[:timestamp_field_name] || "timestamp"

        init_redis(hash[:host], hash[:port])
      end

      private

      def init_redis(host, port)
        host ||= "127.0.0.1"
        port = (port || 6379).to_i
        @redis = Redis.new(host: host, port: port)
      end

      def canonical_log(logevent)
        json = JsonFormatter.format(logevent, @index, @data_field_name,
                                    @level_field_name,
                                    @additional_fields)
        tries = 3
        begin
          Retryable.retryable(tries: tries, sleep: ->(n) { 2**n }) do
            @redis.rpush @index, json
          end
        rescue
          raise "Unable to connect to #{@redis.inspect} after #{tries} tries. \
Please confirm your ability to connect to that redis instance."
        end
      end
    end
  end
end
