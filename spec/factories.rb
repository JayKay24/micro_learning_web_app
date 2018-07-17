require 'factory_bot'

FactoryBot.define do
  factory :user do
    first_name 'Clark'
    last_name 'Kent'
    email 'clark@example.com'
    password 'Qwertyuiop123#'
  end
end