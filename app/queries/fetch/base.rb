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

  protected

  def strip_data(data)
    data.each do |row|
      row['invitee'].strip!
      row['inviter'].strip!
    end
    data
  end
end
