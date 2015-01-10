FactoryGirl.define do
  factory :player do
  	association(:game)
  	association(:user)
  end
end