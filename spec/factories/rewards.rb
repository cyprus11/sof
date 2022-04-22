FactoryBot.define do
  sequence :name do |n|
    "Reward#{n}"
  end

  factory :reward do
    name
    question
    user { nil }
    file { Rack::Test::UploadedFile.new("#{Rails.root}/public/kubok.png", "image/png") }
  end
end
