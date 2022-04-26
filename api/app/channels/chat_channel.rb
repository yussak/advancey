class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    Message.create!(content: data['message'], user_id: data['user_id'], community_id: data['community_id'])
    ActionCable.server.broadcast 'chat_channel', { message: data['message'] }
  end

  def destroy(data)
    message = Message.find_by(id: data['message_id'])
    message.destroy
    ActionCable.server.broadcast 'chat_channel', { message: data['message_id'] }
  end
end
