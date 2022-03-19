class V1::CommunitiesController < ApplicationController
  def index
    communities = Community.all
    render json: communities
  end

  def create
    # a
    # メソッドで中間のcreateにPOSTするのかも
  end
end
