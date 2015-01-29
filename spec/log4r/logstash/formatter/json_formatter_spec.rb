require "log4r/logstash/formatter/json_formatter"
require "log4r/logger"
require "log4r/logevent"
require "securerandom"

describe Log4r::Logstash::JsonFormatter do
  let(:logevent) do
    logger = Log4r::Logger.new("my test logger")
    Log4r::LogEvent.new(1, logger, nil, "my test log message")
  end
  let(:index) { "my_index_name" }

  describe "basic formatting" do
    it "handles a log event" do
      json = Log4r::Logstash::JsonFormatter.format(logevent, index)
      expect(json).to include('"type":"Log4r::LogEvent"')
      expect(json).to include('"index":"my_index_name"')
      expect(json).to include('"timestamp":')
      expect(json).to include('"level":"DEBUG"')
      expect(json).to include('"data":"my test log message"')
    end
  end

  describe "data field name" do
    it "can be overridden" do
      expect(Log4r::Logstash::JsonFormatter.format(logevent, index, "DATA")).to include('"DATA":"my test log message"')
    end
  end

  describe "level field name" do
    it "can be overridden" do
      expect(Log4r::Logstash::JsonFormatter.format(logevent, index, nil, "LEVEL")).to include('"LEVEL":"DEBUG"')
    end
  end

  describe "additional fields" do
    it "include literals" do
      additional_fields = {}
      additional_fields["foo"] = "bar"
      additional_fields["goo"] = "baz"
      json = Log4r::Logstash::JsonFormatter.format(logevent, index, nil, nil, additional_fields)
      expect(json).to include('"foo":"bar"')
      expect(json).to include('"goo":"baz"')
    end

    it "evaluates lambdas" do
      r = SecureRandom.uuid
      additional_fields = {}
      additional_fields["foo"] = -> { r }
      json = Log4r::Logstash::JsonFormatter.format(logevent, index, nil, nil, additional_fields)
      expect(json).to include('"foo":"' + r + '"')
    end
  end
end
