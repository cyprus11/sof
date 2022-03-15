require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should has_many :answers }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
