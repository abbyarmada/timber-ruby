module Timber
  module LogDevices
    class IO < LogDevice
      class JSONFormatter < Formatter
        def format(log_line)
          log_line.to_json
        end
      end
    end
  end
end