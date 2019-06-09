module Gps
  module Nmea
    class Gsa < Sentence
      attr_accessor :forced, :mode, :sv_id, :pdop, :hdop, :vdop

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private
      
      def fill_data
        @forced = @parts[0] == 'M'
        @mode = @parts[1].to_i
        @sv_id = 0
        (2..13).each do |i|
          @sv_id += ((12 - i) * 100) * @parts[i].to_i
        end
        @pdop = @parts[14].to_f
        @hdop = @parts[15].to_f
        @vdop = @parts[16].to_f
      end
    end
  end
end
