class V1::StaticPagesController < ApplicationController
  # ECSデプロイのため
  def home
    head 200
  end

  def about; end

  def contact; end
end
