class Fetch::Base
  extend ActiveModel::Callbacks
  include ActiveModel::Validations

  attr_reader :options

  define_model_callbacks :initialize

  def initialize(options = {})
    run_callbacks :initialize do
      @options = options.stringify_keys
    end
  end

  def execute
    # Redefine this method in the inheritable class
  end
end
