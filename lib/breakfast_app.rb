# frozen_string_literal: true

class BreakfastApp
  def self.call(price_list_json, orders_json)
    parsed_orders = JSON.parse(orders_json)
    parsed_list = JSON.parse(price_list_json)

    CalculateChange.new(parsed_orders, parsed_list).calculate
  end
end
