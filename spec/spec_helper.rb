require 'bundler/setup'
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Event.all.each { |event| event.destroy }
  end
end
