class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @result = SphinxFinder.new(params).call
  end
end