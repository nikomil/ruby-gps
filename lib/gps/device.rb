module Gps
  class Device
    attr_accessor :last_datetime # Updates any time a sentence has a datetime

    def initialize(filename, track_datetime=true)
      @callbacks = {}
      @track_datetime = track_datetime
      @filename = filename
      @file = File.open(filename, 'rb')
    end

    def self.open(filename, &block)
      device = Device.new filename
      block.call device
      device.close
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

    def each_coordinates(&block)
      each_sentence do |sentence|
        block.call sentence.lat_long_dec if sentence.has_coordinates?
      end
    end

    # Rewind file if not a character device
    def rewind
      @file.rewind unless File.chardev?(@file.path)
    end

    # Begin fetch process with callbacks
    def start
      @stopped = false
      each_sentence do |sentence|
        break if @stopped

        if @callbacks[:coordinates] && sentence.has_coordinates?
          @callbacks[:coordinates].each do |block|
            block.call sentence.lat_long_dec
          end
        end


        if @callbacks[:datetime] && sentence.has_datetime?
          @callbacks[:datetime].each do |block|
            block.call sentence.datetime
          end
        end

        if @callbacks[:speed_knots] && sentence.respond_to?(:speed_knots)
          @callbacks[:speed_knots].each do |block|
            block.call sentence.speed_knots if sentence.speed_knots
          end
        end

        if @callbacks[:speed_kmh] && sentence.respond_to?(:speed_kmh)
          @callbacks[:speed_kmh].each do |block|
            block.call sentence.speed_kmh if sentence.speed_kmh
          end
        end

        if @callbacks[:altitude] && sentence.respond_to?(:altitude)
          @callbacks[:altitude].each do |block|
            block.call sentence.altitude if sentence.altitude
          end
        end

        if @callbacks[:true_track] && sentence.respond_to?(:true_track)
          @callbacks[:true_track].each do |block|
            block.call sentence.true_track if sentence.true_track
          end
        end

        if @callbacks[:magnetic_track] && sentence.respond_to?(:magnetic_track)
          @callbacks[:magnetic_track].each do |block|
            block.call sentence.magnetic_track if sentence.magnetic_track
          end
        end
      end

      if @callbacks[:complete]
        @callbacks[:complete].each(&:call)
      end
    end

    def start_async
      Thread.new(&method(:start))
    end

    def stop
      @stopped = true
    end

    def on_coordinates(&block)
      callbacks[:coordinates] ||= []
      callbacks[:coordinates] << block
    end

    def on_datetime(&block)
      callbacks[:datetime] ||= []
      callbacks[:datetime] << block
    end

    def on_speed_knots(&block)
      callbacks[:speed_knots] ||= []
      callbacks[:speed_knots] << block
    end

    def on_speed_kmh(&block)
      callbacks[:speed_kmh] ||= []
      callbacks[:speed_kmh] << block
    end

    def on_altitude(&block)
      callbacks[:altitude] ||= []
      callbacks[:altitude] << block
    end

    def on_complete(&block)
      callbacks[:complete] ||= []
      callbacks[:complete] << block
    end

    def on_true_track(&block)
      callbacks[:true_track] ||= []
      callbacks[:true_track] << block
    end

    def on_magnetic_track(&block)
      callbacks[:magnetic_track] ||= []
      callbacks[:magnetic_track] << block
    end

    private

    attr_reader :callbacks

    def update_datetime(sentence)
      if sentence.respond_to? :datetime
        @last_datetime = sentence.datetime
      end
    end
  end
end
