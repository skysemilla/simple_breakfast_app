# frozen_string_literal: true

require 'spec_helper'
require 'breakfast_app'
require 'json'

# Loading the class from services
$LOAD_PATH.unshift(File.dirname(__FILE__), 'app/services')
require 'calculate_change'

describe BreakfastApp do
  # let(:price_list_json) do
  #   <<-JSON
  #   [
  #     { "id": "flat-white", "name": "Flat White", "price": 3.0 },
  #     { "id": "espresso", "name": "Espresso", "price": 2.0 },
  #     { "id": "bacon-egg-roll", "name": "Bacon & Egg Roll", "price": 5.0 },
  #     { "id": "bbq-sauce", "name": "BBQ Sauce", "price": 0.0 }
  #   ]
  #   JSON
  # end

  # let(:orders_json) do
  #   <<-JSON
  #   [
  #     { "name": "dave", "money": 10.0, "items": ["flat-white", "bacon-egg-roll", "bbq-sauce"] },
  #     { "name": "jenny", "money": 5.0, "items": ["espresso"] }
  #   ]
  #   JSON
  # end

  # Use fixtures
  let(:price_list_json) { File.open('spec/fixtures/price_list.json', 'r').read }
  let(:orders_json) { File.open('spec/fixtures/orders.json', 'r').read }
  let(:result_json) do
    <<-JSON
    [
      { "name": "dave", "change": 2.0 },
      { "name": "jenny", "change": 3.0 }
    ]
    JSON
  end

  subject(:breakfast_app_result) { described_class.call(price_list_json, orders_json) }

  context 'with valid orders' do
    # Changed JSON.load to JSON.parse
    let(:parsed_result) { JSON.parse(breakfast_app_result) }

    # Removed 'should' since it is a bad practice (reference: https://www.betterspecs.org/)
    it 'matches the expected result' do
      expect(parsed_result).to eq JSON.parse(result_json)
    end

    it 'contains 2 records' do
      expect(parsed_result.count).to eq 2
    end

    it 'provides the correct change' do
      expect(parsed_result[0]['change']).to eq 2.0
      expect(parsed_result[1]['change']).to eq 3.0
    end
  end

  context 'with invalid orders' do
    let(:orders_json) do
      <<-JSON
      [
        { "name": "dave", "items": ["flat-white", "bacon-egg-roll", "bbq-sauce"] },
        { "name": "jenny", "money": 5.0}
      ]
      JSON
    end

    it 'returns an error' do
      expect(breakfast_app_result).to include('[INVALID-ORDER][ERROR]')
    end
  end
end
