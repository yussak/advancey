class V1::MessagesController < ApplicationController
  def destroy
    message = Message.find(params[:id])
    render json: message if message.destroy
  end
end
