FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commentable { nil }
    user
  end
end
