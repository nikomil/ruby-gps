# ruby-gps
Simple GPS utilities for Ruby. Currently just parses a few NMEA sentences. More to come!

### Example
Reading GPS serial device
```ruby
Gps::Device.open '/dev/ttyUSB0' do |device|
  # Fetch sentences as they come through
  device.each_sentence do |s|
    puts s.to_json pretty: true
    case
    when s.is_a?(Gps::Nmea::Gga)
      # GPGGA
      puts s.lat_long_dec
      puts s.time
      puts s.num_satellites
      # etc...
    when s.is_a?(Gps::Nmea::Gll)
      # GPGLL
    when s.is_a?(Gps::Nmea::Gsa)
      # GPGSA
    when s.is_a?(Gps::Nmea::Gsv)
      # GPGSV
    when s.is_a?(Gps::Nmea::Vtg)
      # GPVTG
    when s.is_a?(Gps::Nmea::Zda)
      # GPSZDA
    when s.is_a?(Gps::Nmea::Rmc)
      # GPRMC
    else
      puts "Not yet implemented"
    end
  end

  # Fetch coordinates from sentences as they come through (converted to decimal format)
  device.each_coordinates do |coords|
    puts "Last known timestamp: #{device.last_datetime}" unless device.last_datetime.nil?
    puts "Location: #{coords}"
  end
end
```

Using callbacks for specific data
```ruby
device = Gps::Device.new 'nmea_data.txt'

device.on_coordinates do |coords|
  puts "Location: #{coords}"
end

device.on_datetime do |datetime|
  puts "Date: #{datetime.to_s}"
end

device.on_speed_knots do |speed|
  puts "Speed: #{speed} knots"
end

device.on_speed_kmh do |speed|
  puts "Speed: #{speed} kmh"
end

device.on_altitude do |altitude|
  puts "Altitude: #{altitude} meters"
end

device.on_true_track do |true_track|
  puts "True track: #{true_track}"
end

device.on_magnetic_track do |mag_track|
  puts "Magnetic track: #{mag_track}"
end

device.on_complete do
  puts "Done!"
end

# Synchronous
device.start

# Asynchronous
device.rewind
thread = device.start_async
thread.join
```