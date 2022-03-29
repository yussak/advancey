class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    user = User.find_by(params[:user_id])
    if message = Message.create(content: data['message'], user_id: user.id)
      ActionCable.server.broadcast 'room_channel',
                                   { message: data['message'], name: user.name, created_at: message.created_at }
    end
  end
end
