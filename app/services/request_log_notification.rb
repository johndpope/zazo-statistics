class RequestLogNotification
  include ActiveModel::Validations

  attr_reader :push_user
  validate :push_user_must_be_valid
  validate :device_must_be_android

  def initialize(user)
    @push_user = PushUser.find_by_mkey(user.mkey)
  end

  def do
    if valid?
      handle_response NotificationApi.new(notification_data).mobile
    else
      false
    end
  end

  private

  def notification_data
    { subject: 'log_request',
      device_platform: 'android',
      device_token: push_user.push_token,
      payload: {
        host: "#{(Rails.env.production? ? 'prod' : 'staging')}.zazoapp.com",
        type: 'log_request',
        date_start: Time.now.strftime('%m/%d/%Y'),
        date_end:   Time.now.strftime('%m/%d/%Y')
      } }
  end

  def handle_response(res)
    if res['status'] == 'success'
      true
    else
      errors.add :response, res.to_s
      false
    end
  end

  #
  # validations
  #

  def push_user_must_be_valid
    errors.add :push_user, 'not found by mkey' unless push_user
  end

  def device_must_be_android
    if push_user && push_user.device_platform != :android
      errors.add :push_user, 'must have android device platform'
    end
  end
end
