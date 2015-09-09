class Fetch::Users::FindByMobileOrEmail < Fetch::Base
  attr_accessor :email, :mobile

  after_initialize :set_options

  def execute
    user = User.where('mobile_number = ? OR email = ?', mobile, email).first
    { id: user.try(:id), mkey: user.try(:mkey) }
  end

  private

  def set_options
    @email  = options['email']
    @mobile = options['mobile']
  end
end
