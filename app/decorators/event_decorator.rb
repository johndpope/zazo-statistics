class EventDecorator < Draper::Decorator
  delegate_all

  def name
    object.name.join(':')
  end

  def data
    h.content_tag :pre, JSON.neat_generate(object.data)
  end

  def raw_params
    h.content_tag :pre, JSON.neat_generate(object.raw_params)
  end
end
