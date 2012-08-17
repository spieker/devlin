require 'factory_girl'

FactoryGirl.define do
  factory :transaction do
    user_id 1
    manufacturer 'M1'
    date Date.parse('2012-08-18')
    costs 100
  end
end
