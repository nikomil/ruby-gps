module Gps
  module Nmea
    class Zda < Sentence
      attr_accessor :hour, :minute, :second, :day, :month, :year,
                    :local_zone_desc, :local_zone_minutes

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private

      def fill_data
        hms = @parts[0]
        @hour = hms[0..1].to_i
        @minute = hms[2..3].to_i
        @second = hms[4..5].to_i
        @day = @parts[1].to_i
        @month = @parts[2].to_i
        @year = @parts[3].to_i
        @local_zone_desc = @parts[4].to_i
        @local_zone_minutes = @parts[5].to_i
      end
    end
  end
end
