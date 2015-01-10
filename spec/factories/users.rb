FactoryGirl.define do
  factory :user do
  	sequence(:username) {|i| "rails_tester#{i}"}
  	sequence(:email) { |i| "email#{i}@mail.com"}
  	password "password"
  end
end