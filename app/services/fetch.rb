class Fetch
  class UnknownClass   < StandardError; end
  class InvalidOptions < StandardError; end

  attr_reader :options, :prefix, :name

  def initialize(prefix, name, options = {})
    @options = options
    @prefix  = prefix
    @name    = name
  end

  def do
    instance = Classifier.new([:fetch, prefix, name].compact).klass.new options
    if instance.valid?
      instance.execute
    else
      fail InvalidOptions, instance.errors.messages.to_json
    end
  rescue NameError
    raise UnknownClass, "#{[prefix, name].compact.map(&:to_s).map(&:camelize).join '::'} class not found"
  end
end
