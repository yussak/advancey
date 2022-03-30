class V1::MessagesController < ApplicationController
  def index
    messages = Message.all
    render json: messages.to_json(except: [:updated_at], include: [{ user: { only: [:name] } }])
  end

  def destroy
    message = Message.find(params[:id])
    render json: message if message.destroy
  end
end
