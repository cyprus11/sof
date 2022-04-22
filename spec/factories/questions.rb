FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    best_answer_id { nil }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      files {[Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", "text/x-ruby")]}
    end

    trait :with_gist_link do
      links { [Link.new(name: 'Gist url', url: 'https://gist.github.com/user/123456789')] }
    end

    trait :with_link do
      links { [Link.new(name: 'Url', url: 'https://www.google.ru')] }
    end
  end
end
