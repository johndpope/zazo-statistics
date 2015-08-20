class Fetch::Country < Fetch::Base
  attr_accessor :user, :phone

  after_initialize :set_options

  validates :user, presence: true
  validate :valid_phone?

  def execute
    { phone:   phone.original,
      country: phone.country }
  end

  private

  def set_options
    @user  = User.find_by mkey: options['user']
    @phone = Phonelib.parse(user.mobile_number) if user
  end

  def valid_phone?
    if user && !phone.valid?
      errors.add :phone, 'phone is incorrect'
    end
  end
end
