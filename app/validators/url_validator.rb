class UrlValidator < ActiveModel::Validator
  def validate(record)
    url = URI.parse(record.url) rescue false
    record.errors.add :url, 'URL not valid' unless url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end