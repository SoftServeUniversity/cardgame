FactoryGirl.define do
  factory :game do
  	sequence(:name) { |i| "Game#{i}"}
  	sequence(:description) { |i| "this game#{i} only for pro gamers"}
  end
end