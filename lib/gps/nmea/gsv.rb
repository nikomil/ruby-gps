module Gps
  module Nmea
    class Gsv < Sentence
      attr_accessor :num_messages, :message_num, :total_svs, :sv_prn,
                    :elevation, :azimuth, :snr

      def initialize(line)
        @line = line
        fill_parts
        fill_data
      end

      private

      def fill_data
        @num_messages = @parts[0].to_i
        @message_num = @parts[1].to_i
        @total_svs = @parts[2].to_i
        @sv_prn = @parts[3].to_i
        @elevation = @parts[4].to_i
        @azimuth = @parts[5].to_i
        @snr = @parts[6].to_i
      end
    end
  end
end
