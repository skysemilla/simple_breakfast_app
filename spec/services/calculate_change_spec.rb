# frozen_string_literal: true

require 'spec_helper'
require 'json'

# Loading the class from services
$LOAD_PATH.unshift(File.dirname(__FILE__), 'app/services')
require 'calculate_change'

describe CalculateChange do
  let(:price_list) { File.open('spec/fixtures/price_list.json', 'r').read }
  let(:orders) { File.open('spec/fixtures/orders.json', 'r').read }
  let(:result_json) do
    [
      { name: 'dave', change: 2.0 },
      { name: 'jenny', change: 3.0 }
    ].to_json
  end

  subject(:initialized_class) { described_class.new(JSON.parse(orders), JSON.parse(price_list)) }

  context '#calculate' do
    let(:calculate_change) { initialized_class.calculate }
    it 'matches the expected result' do
      expect(calculate_change).to eq result_json
    end
  end

  context '#order_items' do
    let(:order_items) { initialized_class.send(:order_items, JSON.parse(orders).first) }

    it 'matches the items ordered' do
      item_ids = order_items.map { |item| item['id'] }
      expect(JSON.parse(orders).first['items']).to match_array(item_ids)
    end
  end
end
