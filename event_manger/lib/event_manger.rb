require 'csv'

puts 'Event Manager Initialized!'

conlines = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

# all_name = {}
# conlines.each_with_index do |line,index|
#   # puts line
#   next if index == 0
#   col = line.split(',')
#   name = col[2]
#   all_name["name#{index}"] = name
# end

conlines.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  if zipcode.length < 5
    zipcode = zipcode.rjust(5, '0')
  elsif zipcode.length > 5
    zipcode = zipcode[0..4]
  end

  puts "#{name},#{zipcode}"
end

p conlines
