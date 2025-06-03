# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if ENV['CLEAN_ORDERS'] == 'true'
  orders_count = Order.count
  Order.delete_all
  puts "#{orders_count} orders deleted successfully."
end

orders_count = ENV.fetch('ORDER_COUNT', 10000).to_i
orders_count.times do
  status = [ 'delivered', 'pending', 'canceled' ].sample
  placed_at = Date.today + rand(-99..100)
  amount = rand(100..9999)

  Order.create!(
    status: status,
    placed_at: placed_at,
    delivered_at: status == 'delivered' ? placed_at + rand(2..7) : nil,
    amount: rand(100..9999),
    tax: amount * 0.18,
    street_address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state,
    country: Faker::Address.country,
    pincode: Faker::Address.zip_code
  )
end

puts "#{orders_count} orders created successfully."
