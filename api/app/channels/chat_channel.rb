class ChatChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "chat_#{params[:community_id]}"
    # stream_from "chat_#{params[:community]}"
    stream_from 'chat_channel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    # user = User.find_by(params[:user_id])
    # if message = Message.create(content: data['message'], user_id: user.id)
    #   ActionCable.server.broadcast 'chat_channel',
    #                                { message: data['message'] }
    # end
    user = User.find_by(params[:user_id])
    Message.create!(content: data['message'], user_id: user.id, community_id: params['community_id'])
  end
end
