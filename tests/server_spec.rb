require 'rack/test'
require 'json'
require_relative '../server'

describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:valid_receipt_data) do
    {
      retailer: 'Target',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '1.25',
      items: [{ shortDescription: 'Pepsi - 12-oz', price: '1.25' }]
    }
  end

  let(:invalid_receipt_data) do
    {
      # retailer: 'Target',
      purchaseDate: '2022-01-02',
      purchaseTime: '13:13',
      total: '1.25',
      items: [{ shortDescription: 'Pepsi - 12-oz', price: '1.25' }]
    }
  end

  describe 'POST /receipts/process' do
    it 'returns a 200 status code with receipt ID for valid data' do
      post '/receipts/process', valid_receipt_data.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body['id']).not_to be_nil
    end

    it 'returns a 422 status code and validation errors for invalid data' do
      post '/receipts/process', invalid_receipt_data.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql(422)
      response_body = JSON.parse(last_response.body)
      expect(response_body).not_to be_empty
    end

    it 'returns a 400 status code and validation errors for malformed request body' do
      post '/receipts/process', invalid_receipt_data, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql(400)
      response_body = JSON.parse(last_response.body)
      expect(response_body).not_to be_empty
    end
  end

  describe 'GET /receipts/:id/points' do
    it 'returns the points for a valid receipt ID' do
      post '/receipts/process', valid_receipt_data.to_json, 'CONTENT_TYPE' => 'application/json'
      response_body = JSON.parse(last_response.body)
      receipt_id = response_body['id']

      get "/receipts/#{receipt_id}/points"
      expect(last_response.status).to eql(200)
      response_body = JSON.parse(last_response.body)
      expect(response_body['points']).to be_a(Integer)
    end

    it 'returns a 404 status code for an invalid receipt ID' do
      get '/receipts/invalid_id/points'
      expect(last_response.status).to eql(404)
      response_body = JSON.parse(last_response.body)
      expect(response_body['error']).to match('No receipt found for that ID.')
    end
  end
end
