class Fetch::Attributes < Fetch::Base
  ALLOWED_ATTRS = %w(id mkey status first_name last_name email mobile_number device_platform)

  attr_accessor :user, :attrs

  after_initialize :set_options

  validates :user, :attrs, presence: true
  validate :attrs_allowed?

  def execute
    attrs.each_with_object({}) do |attr, memo|
      memo[attr] = user.send attr
    end
  end

  private

  def set_options
    @user  = User.find_by mkey: options['user']
    @attrs = Array options['attrs']
  end

  def attrs_allowed?
    attrs.each do |attr|
      unless ALLOWED_ATTRS.include?(attr.to_s) ||
             ALLOWED_ATTRS.include?(attr.to_sym)
        errors.add :attrs, "attr #{attr} is not allowed"
      end
    end
  end
end
