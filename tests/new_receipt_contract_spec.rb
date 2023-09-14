require 'dry-validation'
require 'rspec'
require_relative '../contracts/new_receipt_contract'

describe NewReceiptContract do
  subject(:contract) { described_class.new }

  it 'successfully validates a valid receipt' do
    valid_data = {
      retailer: 'Target',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '1.25',
      items: [
        { shortDescription: 'Pepsi - 12-oz', price: '1.25' }
      ]
    }

    expect(contract.call(valid_data)).to be_success
  end

  it 'rejects an invalid retailer' do
    invalid_data = {
      retailer: ' Invalid Retailer   ', # Whitespaces before and after
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '10000.00',
      items: [
        { shortDescription: 'Pepsi - 12-oz', price: '1.25' }
      ]
    }

    expect(contract.call(invalid_data)).to_not be_success
  end

  it 'rejects an invalid purchase time' do
    invalid_data = {
      retailer: 'Walgreens',
      purchaseDate: '2022-01-02',
      purchaseTime: '4:19',
      total: '100.21',
      items: [
        { shortDescription: 'Pepsi - 12-oz', price: '1.25' }
      ]
    }

    expect(contract.call(invalid_data)).to_not be_success
  end

  it 'rejects an invalid short description' do
    invalid_data = {
      retailer: 'Walgreens',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '123.40',
      items: [
        { shortDescription: '', price: '1.25' }
      ]
    }

    expect(contract.call(invalid_data)).to_not be_success
  end

  it 'rejects an invalid total price' do
    invalid_data = {
      retailer: 'Walgreens',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '12.3',
      items: [
        { shortDescription: 'Pepsi - 12-oz', price: '1.25' }
      ]
    }

    expect(contract.call(invalid_data)).to_not be_success
  end

  it 'rejects an invalid item price' do
    invalid_data = {
      retailer: 'Walgreens',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '12.30',
      items: [
        { shortDescription: 'Pepsi - 12-oz', price: '1.25' },
        { shortDescription: 'Dr. Salt - 24-oz', price: '25' }
      ]
    }

    expect(contract.call(invalid_data)).to_not be_success
  end
end
