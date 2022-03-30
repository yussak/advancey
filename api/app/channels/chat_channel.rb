class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    user = User.find_by(params[:user_id])
    Message.create!(content: data['message'], user_id: user.id, community_id: data['community_id'])
    ActionCable.server.broadcast 'chat_channel', { message: data['message'] }
  end

  def destroy
    message = Message.find_by(params[:message_id])
    message.destroy!
    ActionCable.server.broadcast 'chat_channel', { message_id: message.id }
  end
end
