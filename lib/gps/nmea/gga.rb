require 'time'

module Gps
  module Nmea
    class Gga < Sentence
      attr_accessor :time, :time_str, :latitude, :latitude_direction, :longitude,
                    :longitude_direction, :fix_quality, :num_satellites, :hdop,
                    :altitude, :altitude_unit, :age_of_diff

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private

      def fill_data
        @time_str = Sentence.time_part_to_str @parts[0]
        @time = Time.parse time_str
        @latitude = @parts[1].to_f
        @latitude_direction = @parts[2]
        @longitude = @parts[3].to_f
        @longitude_direction = @parts[4]
        @fix_quality = @parts[5].to_i
        @num_satellites = @parts[6].to_i
        @hdop = @parts[7].to_f
        @altitude = @parts[8].to_f
        @altitude_unit = @parts[9]
        @age_of_diff = @parts[10].to_f
      end
    end
  end
end
