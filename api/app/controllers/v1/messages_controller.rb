class V1::MessagesController < ApplicationController
  def index
    messages = Message.all
    render json: messages.to_json(except: [:updated_at])
  end
end
