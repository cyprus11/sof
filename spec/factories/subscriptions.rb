FactoryBot.define do
  factory :subscription do
    user

    trait :question_as_subscribe do
      subscriptionable { create(:question) }
    end
  end
end
