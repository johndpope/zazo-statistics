class Event < Hashie::Mash
  def name_as_string
    key?('name') && name.join(':') || ''
  end
end
