class ConnectionDecorator < Draper::Decorator
  delegate_all

  def direction_arrow(user_id)
    object.creator.id == user_id ? '<- (target)' : '-> (creator)'
  end

  def friend_info(user_id)
    if object.creator.id == user_id
      user = object.target
    else
      user = object.creator
    end
    h.link_to "#{user.name} (#{user.mobile_number})", user
  end
end
