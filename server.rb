require 'sinatra'
require 'json'
require_relative 'models/receipt'
require_relative 'contracts/new_receipt_contract'
require 'pry'
require 'puma'

receipt_store = {} # store receipt objects

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
    return { errors: errors.to_json }.to_json
  end

  receipt = Receipt.new(request_data)
  receipt_store[receipt.id.to_sym] = receipt
  return { id: receipt.id.to_s }.to_json
end

get '/receipts/:id/points' do
  content_type :json

  receipt_id = params[:id]

  if receipt_store.key?(receipt_id.to_sym)
    receipt = receipt_store[receipt_id.to_sym]

    points = receipt.points

    return { points: points }.to_json
  else
    status 404
    return { error: "Receipt with ID #{receipt_id} not found" }.to_json
  end
end
