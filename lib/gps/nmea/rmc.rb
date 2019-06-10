require 'time'
require 'date'

module Gps
  module Nmea
    class Rmc < Sentence
      attr_accessor :time_str, :time, :data_status, :latitude, :latitude_direction,
                    :longitude, :longitude_direction, :speed_knots, :true_track,
                    :date_str, :date, :variation, :variation_direction

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private

      def fill_data
        @time_str = Sentence.time_part_to_str @parts[0]
        @time = Time.parse @time_str
        @data_status = @parts[1]
        @latitude = @parts[2]
        @latitude_direction = @parts[3]
        @longitude = @parts[4]
        @longitude_direction = @parts[5]
        @speed_knots = @parts[6]
        @true_track = @parts[7]
        @date_str = Sentence.date_part_to_str @parts[8]
        @date = Date.parse @date_str
        @variation = @parts[9]
        @variation_direction = @parts[10]
      end
    end
  end
end
