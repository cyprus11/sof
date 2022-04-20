class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_with UrlValidator

  def gist?
    self.url&.start_with? 'https://gist.github.com/'
  end

  def gist_id
    return unless gist?

    self.url.split('/').last
  end
end