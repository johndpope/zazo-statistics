class Fetch
  class UnknownClass < StandardError; end

  attr_reader :options, :prefix, :name

  def initialize(prefix, name, options = {})
    @options = options
    @prefix  = prefix
    @name    = name
  end

  def do
    Classifier.new([prefix, name]).klass.new(options).execute
  rescue NameError
    raise UnknownClass, "#{[prefix, name].compact.map(&:camelize).join '::'} class not found"
  end
end
