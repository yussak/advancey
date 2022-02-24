class V1::TopicsController < ApplicationController
  def index
    # テキスト表示
    # render plain: 'test' # text:だとエラーになった
    topics = Topic.all
    render json: topics
  end
end
