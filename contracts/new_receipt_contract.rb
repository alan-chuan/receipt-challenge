require 'dry-validation'

class NewReceiptContract < Dry::Validation::Contract
  RETAILER_REGEX = /^(?! )[\S ]*(?<! )$/.freeze
  TIME_REGEX = /^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/.freeze
  SHORT_DESCRIPTION_REGEX = /^[\w\s-]+$/.freeze
  PRICE_REGEX = /^\d+\.\d{2}$/.freeze

  schema do
    required(:retailer).filled(:string) { format?(RETAILER_REGEX) }
    required(:purchaseDate).filled('params.date')
    required(:purchaseTime).filled(:string) { format?(TIME_REGEX) }
    required(:total).filled(:string) { format?(PRICE_REGEX) }

    required(:items).array(:hash) do
      required(:shortDescription).filled(:string) { format?(SHORT_DESCRIPTION_REGEX) }
      required(:price).filled(:string) { format?(PRICE_REGEX) }
    end
  end
end
