require 'spec_helper'

describe Event do
  it 'should return all events that are in the future' do
    date = "2014/05/15 [12:00:00]"
    test_event = Event.create(:description => 'Feed the dog', :location => 'Home', :start => Time.now, :end => date.parse )
  end
end
