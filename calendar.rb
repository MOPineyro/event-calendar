require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

require 'time'
require 'date'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])


def main_menu
  puts "c - create event"
  puts "e - edit event"
  puts "d - delete event"
  puts "l - list all event"
  puts "ld - list all events for today"
  puts "lw - list all events this week"
  puts "lnw - list all events next week"
  puts "lm - list all events for the month"
  puts "lnm - list all events for next month"
  puts "x - exit"

  input = nil
  until input == 'x'
    case input = gets.chomp
      when 'c' then create_event
      when 'e' then edit_event
      when 'd' then delete_event
      when 'l' then list_event
      when 'ld' then show_all_today
      when 'lw' then show_all_week
      when 'lnw' then show_all_next_week
      when 'lm' then show_all_month
      when 'lnm' then show_all_next_month
    end
  end
  puts "Peace!"
end

def create_event
  puts 'Event description:'
  description = gets.chomp
  puts 'Event location:'
  location = gets.chomp
  puts 'Enter event start date & time (mm/dd/yy hh:mm)'
  start = gets.chomp
  puts 'Enter event end date & time (mm/dd/yy hh:mm)'
  end_time = gets.chomp
  event = Event.create({:description => description, :location => location, :start => start, :end => end_time })
  puts "Event created!"
  puts "Add another event? (Y/N)"
  add_another = gets.chomp.upcase
  add_another == "Y" ? create_event : main_menu
end

def edit_event
  Event.all.each {|event| puts "(#{event.id}) - #{event.description}"}
  puts "Select event you would like to edit"
  event_selection = gets.chomp.to_i
  event_to_edit = Event.find(event_selection)
  puts "Edit description - d \t, location - l \t, start date/time - sd\t, end date/time - ed, main menu -m"
  event_property_to_edit = gets.chomp
  case event_property_to_edit
    when 'd'
      edit_description
    when 'l'
      list_event
    when 'sd'
      edit_start
    when 'ed'
      edit_end
    when 'm'
      main_menu
    else
      'invalid input'
      edit_event
  end
end

def show_event
  Event.all.each_with_index do |event, index|
    if event.start > Time.now
      puts "#{index}. #{event.description}"
    elsif Event.all.length == 0
      puts "No events, create one"
      main_menu
    end
  end
end

def delete_event
  show_event
  puts "Choose the event number you would like to delete"
  delete = gets.chomp.to_i
  event = Event.all[delete]
  event.destroy
  puts "Event deleted (or destroyed according to ActiveRecord)"
  main_menu
end

def list_event
  show_event
  puts "Choose an event by its number"
  event_selection = gets.chomp.to_i
  chosen_event = Event.all[event_selection]
  event = Event.find(chosen_event.id)
  system "clear"
  puts "----------------------------------------"
  puts "Event description: #{event.description}"
  puts "Location: #{event.location}"
  puts "Start time: #{event.start}"
  puts "End time: #{event.end}"
  puts "----------------------------------------"
rescue
  puts "invalid input"
  main_menu
end

def edit_description
  puts "what's the new description?"
  new_description = gets.chomp
  event_to_edit.update(description: new_description)
end

def edit_location
  puts "what's the new location?"
  new_location = gets.chomp
  event_to_edit.update(location: new_location)
end

def edit_start
  puts "what's the new start?"
  new_start = gets.chomp
  event_to_edit.update(start: new_start)
end

def edit_end
  puts "what's the new end?"
  new_end = gets.chomp
  event_to_edit.update(:end => new_end)
end

def show_all_today
  binding.pry
  all_events_today = Event.all.where(start.to_date == Date.today)
  if all_events_today.length > 0
    all_events_today.each {|event| puts "#{index}. #{event.description}" }
  else puts "Nothing for today"
  end
end

def show_all_week
  Event.all.each_with_index do |event, index|
        binding.pry
    if event.start.to_date.cweek == Date.today.cweek
      puts "#{index}. #{event.description} - #{event.start.month} - #{event.start.day}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def next_day

  Event.all.each_with_index do |event, index|
    if event.start.day == Date.today.next_day
      puts "#{index}. #{event.description} - #{event.start.month} - #{event.start.day}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def show_all_month
  Event.all.each_with_index do |event, index|
    if event.start.month == Date.today.month
      puts "#{index}. #{event.description} - #{event.start.month} - #{event.start.day}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def show_all_next_month
  Event.all.each_with_index do |event, index|
    if event.start.month == Date.today.next_month
      puts "#{index}. #{event.description} - #{event.start.month} - #{event.start.day}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

main_menu
