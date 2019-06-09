module Gps
  module Nmea
    class Gll < Sentence
      attr_accessor :latitude, :latitude_direction, :longitude, :longitude_direction

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private
      
      def fill_data
        @latitude = @parts[0].to_f
        @latitude_direction = @parts[1]
        @longitude = @parts[2].to_f
        @longitude_direction = @parts[3]
      end
    end
  end
end
