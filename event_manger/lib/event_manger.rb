require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_number(number)
  number = number.delete('^0-9')
  split_number = number.split('')

  if number.length == 10
    "#{number} is good number"
  elsif number.length < 10 || number.length > 11
    "#{number} is bad"
  elsif number.length == 11 && split_number[0] == '1'
    split_number.shift
    "#{split_number.join('')} is good number "
  else
    "#{number} is bad number"
  end
end

  def count_frq(hash)
    max_value = hash.values.max
    hours = []
    hash.each do |key, value|
      hours.push(key) if value == max_value
    end
    hours
    # arr.max_by() { |k,v| v}
  end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
file_length = CSV.read('event_attendees.csv').length

count_hour = Hash.new
count_day = Hash.new

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  phone_number = clean_phone_number(row[5])
  date_time = row[1]

  reg_date_time = DateTime.strptime(date_time, '%m/%d/%y  %H:%M')
  count_hour[reg_date_time.hour] = 1 unless count_hour.has_key?(reg_date_time.hour)
  count_hour[reg_date_time.hour] += 1 if count_hour.has_key?(reg_date_time.hour)

  count_day[reg_date_time.wday] = 1 unless count_day.has_key?(reg_date_time.wday)
  count_day[reg_date_time.wday] += 1 if count_day.has_key?(reg_date_time.wday)
  # form_letter = erb_template.result(binding)

  # save_thank_you_letter(id, form_letter)
end
puts count_day
puts "number of most active hour is #{count_frq(count_hour)}"
puts "number of most day in week is #{count_frq(count_day)}"