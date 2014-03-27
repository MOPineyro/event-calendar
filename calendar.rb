require 'bundler/setup'
Bundler.require(:default)
require 'time'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
def main_menu
  puts "c - create event"
  puts "e - edit event"
  puts "d - delete event"
  puts "l - list event"
  puts "x - exit"

  input = nil
  until input == 'x'
    case input = gets.chomp
      when 'c'
        create_event
      when 'e'
        edit_event
      when 'd'
        delete_event
      when 'l'
        list_event
      when 'x'
        puts 'Good bye'
    end
  end
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
  #     puts "hi"
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
  # binding.pry
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
  Event.all.each_with_index do |event, index|
    if event.start.day == Time.now.day
      puts "#{index}. #{event.description}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def show_all_week
  Event.all.each_with_index do |event, index|
    if event.start.cweek == Time.now.cweek
      puts "#{index}. #{event.description}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def next_day
  Event.all.each_with_index do |event, index|
    if event.start.day == Date.today.next_day
      puts "#{index}. #{event.description}"
    elsif Event.all.length == 0
      puts "No events for today"
      main_menu
    end
  end
end

def show_all_month

end

# main_menu
show_all_today
