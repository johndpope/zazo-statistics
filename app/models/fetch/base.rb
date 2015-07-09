class Fetch::Base
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def execute
    # Redefine this method in the inheritable class
  end
end
