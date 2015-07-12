class Fetch::Attributes < Fetch::Base
  attr_accessor :user, :attrs

  after_initialize :set_options

  validates :user, :attrs, presence: true

  def execute
    attrs.each_with_object({}) do |attr, memo|
      memo[attr] = user.send attr
    end
  end

  private

  def set_options
    @user  = User.find_by mkey: options[:user]
    @attrs = Array options[:attrs]
  end
end
