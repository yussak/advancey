class V1::NewsController < ApplicationController
  def index
    news_list = News.all
    render json: news_list
  end

  def create
    news = News.new(news_params)
    if news.save
      render json: news
    else
      render json: news.errors
    end
  end

  def destroy
    news = News.find(params[:id])
    render json: news if news.destroy
  end

  private

  def news_params
    params.require(:news).permit(:user_id, :content)
  end
end
