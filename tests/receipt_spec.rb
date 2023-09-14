require 'rspec'

require_relative '../models/receipt'

describe Receipt do
  let(:attributes) do
    {
      "retailer": 'Target',
      "purchaseDate": '2022-01-01',
      "purchaseTime": '13:01',
      "items": [
        {
          "shortDescription": 'Mountain Dew 12PK',
          "price": '6.49'
        }, {
          "shortDescription": 'Emils Cheese Pizza',
          "price": '12.25'
        }, {
          "shortDescription": 'Knorr Creamy Chicken',
          "price": '1.26'
        }, {
          "shortDescription": 'Doritos Nacho Cheese',
          "price": '3.35'
        }, {
          "shortDescription": '   Klarbrunn 12-PK 12 FL OZ  ',
          "price": '12.00'
        }
      ],
      "total": '35.35'
    }
  end

  subject(:receipt) { described_class.new(attributes) }

  describe '#initialize' do
    it 'generates a random UUID as ID' do
      expect(receipt.id).to be_a(String)
      expect(receipt.id).to match(/^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$/)
      expect(receipt.id.length).to eq(36)
    end

    it 'sets retailer, purchase_date, purchase_time, total, and items' do
      expect(receipt.retailer).to eq('Target')
      expect(receipt.purchase_date).to eq('2022-01-01')
      expect(receipt.purchase_time).to eq('13:01')
      expect(receipt.total).to eq('35.35')
      expect(receipt.items).to be_an(Array)
      expect(receipt.items.length).to eq(5)
    end
  end

  describe '#points' do
    it 'calculates total points correctly' do
      expect(receipt.points).to eq(28)
    end
  end

  describe 'private methods' do
    it 'calculates points_for_alphanumeric_chars correctly' do
      points = receipt.send(:points_for_alphanumeric_chars, attributes[:retailer])
      expect(points).to eq(6)
    end

    it 'calculates points_for_round_dollar_amount correctly' do
      points = receipt.send(:points_for_round_dollar_amount, attributes[:total])
      expect(points).to eq(0)
    end

    it 'calculates points_for_multiple_of_25_cents correctly' do
      points = receipt.send(:points_for_multiple_of_25_cents, attributes[:total])
      expect(points).to eq(0)
    end

    it 'calculates points_for_every_2_items correctly' do
      points = receipt.send(:points_for_every_2_items, attributes[:items])
      expect(points).to eq(10)
    end

    it 'calculates points_for_item_description correctly' do
      points = receipt.send(:points_for_item_description, attributes[:items])
      expect(points).to eq(6)
    end

    it 'calculates points_for_purchase_day correctly' do
      points = receipt.send(:points_for_purchase_day, attributes[:purchaseDate])
      expect(points).to eq(6)
    end

    it 'calculates points_for_purchase_time correctly' do
      points = receipt.send(:points_for_purchase_time, attributes[:purchaseTime])
      expect(points).to eq(0)
    end
  end
end
