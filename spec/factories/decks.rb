FactoryGirl.define do
  factory :deck do
  	association(:game)
  end
end