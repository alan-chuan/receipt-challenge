require 'sinatra'
require 'json'
require_relative 'models/receipt'
require_relative 'contracts/new_receipt_contract'
require 'pry'
receipt_list = {} # store receipt objects

post '/receipts/process' do
  content_type :json

  begin
    request_data = JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError => e
    status 400
    return { error: "Invalid JSON syntax. #{e}" }.to_json
  end

  contract_result = NewReceiptContract.new.call(request_data)

  unless contract_result.success?
    status 422
    errors = contract_result.errors(full: true).map(&:to_h)
    return errors.to_json
  end

  receipt = Receipt.new(request_data)
  receipt_list[receipt.id.to_sym] = receipt
  return { "id": receipt.id.to_s }.to_json
end
