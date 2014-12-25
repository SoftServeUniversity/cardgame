FactoryGirl.define do
  factory :user do
  	username "rails_tester"
  	sequence(:email) { |i| "email#{i}@mail.com"}
  	password "password"
  end
end