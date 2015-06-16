class Message < Hashie::Mash
  def file_size
    fetch('size', 0)
  end
end
