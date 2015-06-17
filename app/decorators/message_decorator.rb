class MessageDecorator < Draper::Decorator
  delegate_all

  def date
    h.time_ago_in_words object.date
  end

  def file_size
    h.number_to_human_size object.size
  end

  def status
    h.status_tag object.status
  end
end
