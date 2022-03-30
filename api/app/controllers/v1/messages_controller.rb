class V1::MessagesController < ApplicationController
  def index
    # messages = Message.all
    # render json: messages

    messages = Message.all
    msgs_array = messages.map do |message|
      {
        id: message.id,
        user_id: message.user.id,
        content: message.content,
        created_at: message.created_at
      }
    end
    render json: msgs_array
  end
end
