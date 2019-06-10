# ruby-gps
Simple GPS utilities for Ruby. Currently just parses a few NMEA sentences. More to come!

### Example
Reading GPS serial device
```ruby
Gps::Device.open '/dev/ttyUSB0' do |device|
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
end
```
