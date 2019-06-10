module Gps
  class Device
    attr_accessor :last_datetime # Updates any time a sentence has a datetime

    def initialize(filename, track_datetime=true)
      @track_datetime = track_datetime
      @filename = filename
      @file = File.open(filename, 'rb')
    end

    def close
      @file.close if @file
    end

    def each_line(&block)
      @file.each_line do |line|
        line.strip!
        next if line.empty?
        block.call line
      end
    end

    def each_sentence(&block)
      each_line do |line|
        s = Nmea::Sentence.parse line
        next if s.nil?
        update_datetime s if @track_datetime
        block.call s
      end
    end

    def each_coordinate(&block)
      each_sentence do |sentence|
        block.call sentence.lat_long_dec if sentence.has_coordinates?
      end
    end

    def self.open(filename, &block)
      gps_file = Device.new filename
      block.call gps_file
      gps_file.close
    end

    private

    def update_datetime(sentence)
      if sentence.respond_to? :datetime
        @last_datetime = sentence.datetime
      end
    end
  end
end
