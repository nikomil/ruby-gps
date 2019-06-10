require 'date'

module Gps
  module Nmea
    module HasDatetime
      attr_accessor :date_str, :time_str, :datetime

      def update_datetime
        if @date_str && @time_str
          @datetime = DateTime.iso8601 "#{@date_str}T#{@time_str}Z"
        end
      end
    end
  end
end
