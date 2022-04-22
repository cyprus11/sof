class RewardsController < ApplicationController
  def index
    @rewards = current_user.rewards.with_attached_file
  end
end