class Fetch
  class UnknownClass < StandardError; end

  attr_reader :options, :prefix, :name

  def initialize(prefix, name, options = {})
    @options = options
    @prefix  = prefix.to_s
    @name    = name.to_s
  end

  def do
    Classifier.new([prefix, name]).klass.new(options).execute
  rescue NameError
    raise UnknownClass, "#{prefix.camelize}::#{name.camelize} not found"
  end
end
