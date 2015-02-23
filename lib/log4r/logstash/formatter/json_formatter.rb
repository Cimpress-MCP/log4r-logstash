require "json"
require "time"

module Log4r
  module Logstash
    class JsonFormatter
      def self.format(logevent, index,
                     data_field_name = "data", level_field_name = "level",
                     additional_fields = {})
        data = {}
        data["type"] = "#{logevent.class}"
        data["index"] = "#{index}"
        data["timestamp"] = Time.now.getutc.iso8601
        data[level_field_name] = LNAMES[logevent.level]
        data[data_field_name] = logevent.data.force_encoding("UTF-8")
        data.merge! eval_map_proc_values(additional_fields)
        data.to_json
      end

      def self.eval_map_proc_values(map)
        map.each do |key, value|
          map[key] = value.call if value.class == Proc
        end
        map
      end
    end
  end
end
