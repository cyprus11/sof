FactoryBot.define do
  sequence :body do |n|
    "MyAnswer#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files {[Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", "text/x-ruby")]}
    end
  end
end
