class MessageDecorator < Draper::Decorator
  delegate_all

  def date
    h.content_tag :span, h.time_ago_in_words(object.date), title: object.date.to_datetime.to_s(:rfc822)
  end

  def file_size
    h.content_tag :span, h.number_to_human_size(object.size), title: object.size
  end

  def status
    h.status_tag object.status
  end

  def delivered_mark
    h.content_tag :span, '', class: "#{object.delivered}-value"
  end

  def sender
    sender = User.find_by(mkey: object.sender_id)
    h.link_to sender.name, sender
  end

  def receiver
    receiver = User.find_by(mkey: object.receiver_id)
    h.link_to receiver.name, receiver
  end
end
