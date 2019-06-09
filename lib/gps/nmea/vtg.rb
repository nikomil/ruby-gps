module Gps
  module Nmea
    class Vtg < Sentence
      attr_accessor :true_track, :magnetic_track, :speed_knots, :speed_kmh

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private
      
      def fill_data
        @true_track = @parts[0].to_f
        @magnetic_track = @parts[2].to_f
        @speed_knots = @parts[4].to_f
        @speed_kmh = @parts[6].to_f
      end
    end
  end
end
