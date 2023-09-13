require 'securerandom'
require 'time'

class Receipt
  attr_reader :id, :retailer, :purchase_date, :purchase_time, :total, :items

  def initialize(attributes)
    @id = SecureRandom.uuid
    @retailer = attributes[:retailer]
    @purchase_date = attributes[:purchaseDate]
    @purchase_time = attributes[:purchaseTime]
    @total = attributes[:total].to_f
    @items = attributes[:items]
  end

  def points
    total_points = 0
    total_points += points_for_alphanumeric_chars(retailer)
    total_points += points_for_round_dollar_amount(total)
    total_points += points_for_multiple_of_25_cents(total)
    total_points += points_for_every_2_items(items)
    total_points += points_for_item_description(items)
    total_points += points_for_purchase_day(purchase_date)
    total_points += points_for_purchase_time(purchase_time)
    total_points
  end

  private

  def points_for_alphanumeric_chars(retailer)
    # One point for every alphanumeric character in the retailer name.
    retailer.chars.count { |char| char.match?(/\A\w\z/) }
  end

  def points_for_round_dollar_amount(total)
    # 50 points if the total is a round dollar amount with no cents.
    total.to_s.split('.').last == '00' ? 50 : 0
  end

  def points_for_multiple_of_25_cents(total)
    # 25 points if the total is a multiple of 0.25.
    (total % 0.25).zero? ? 25 : 0
  end

  def points_for_every_2_items(items)
    # 5 points for every two items on the receipt.
    ((items.length / 2) * 5)
  end

  def points_for_item_description(items)
    # If the trimmed length of the item description is a multiple of 3,
    # multiply the price by 0.2 and round up to the nearest integer.
    # The result is the number of points earned.
    points_earned = 0
    items.each do |item|
      trimmed_item_description = item[:shortDescription].strip.length
      # puts item[:shortDescription].strip
      # puts trimmed_item_description
      # puts(item[:price].to_f * 0.2).ceil
      points_earned += (item[:price].to_f * 0.2).ceil if (trimmed_item_description % 3).zero?
    end
    points_earned
  end

  def points_for_purchase_day(purchase_date)
    # 6 points if the day in the purchase date is odd.
    purchase_date.split('-')[2].to_i.odd? ? 6 : 0
  end

  def points_for_purchase_time(purchase_time)
    # 10 points if the time of purchase is after 2:00pm and before 4:00pm.
    purchased_at = Time.parse(purchase_time)
    start_time = Time.parse('14:00')
    end_time = Time.parse('16:00')
    purchased_at > start_time && purchased_at < end_time ? 10 : 0
  end
end
