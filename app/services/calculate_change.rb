# frozen_string_literal: true

# Service class for calculating the change for every customer
# This will prevent the BreakfastApp from being bulky with logics
class CalculateChange
  attr_reader :orders, :price_list

  def initialize(orders, price_list)
    @orders = orders
    @price_list = price_list
  end

  def calculate
    # Formula to get the change: customer's money - sum of ordered items amount
    calculated_change = orders.each_with_object([]) do |order, out|
      sum_of_order_items = order_items(order).sum { |item| item['price'].to_f }
      out << { name: order['name'], change: order['money'].to_f - sum_of_order_items }
    end
    calculated_change.to_json
  rescue NoMethodError => e
    # puts "[INVALID-ORDER][ERROR]: #{e.message} " # uncomment this if you want to log the error
    "[INVALID-ORDER][ERROR]: #{e.message} "
  end

  private

  def order_items(order)
    price_list.select { |item| order['items'].include?(item['id']) }
  end
end
