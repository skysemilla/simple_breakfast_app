# frozen_string_literal: true

require 'json'

task :default => [:run]

desc 'load the price list and orders!'
task 'run' do
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')
  require 'breakfast_app'
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'app/services')
  require 'calculate_change'

  # load the data files into strings for you
  price_list_json = File.read('files/price-list.json')
  orders_json = File.read('files/orders.json')

  # call the app, passing the data as strings containing JSON
  result_json = BreakfastApp.call(price_list_json, orders_json)

  # turn the JSON back into a Ruby structure
  result = JSON.parse(result_json)

  # pretty print the output
  puts 'Total:'
  puts format('%-10s%-11s', 'name', 'change')
  puts sprintf('--------')
  result.each do |r|
    puts format('%-10s$%-10.2f', r['name'], r['change'])
  end
end
