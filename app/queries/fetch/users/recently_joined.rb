class Fetch::Users::RecentlyJoined < Fetch::Base
  DEFAULT_TIME_FRAME = 10.years

  attr_accessor :time_frame_in_days
  after_initialize :set_options

  def execute
    User.where('created_at > ?', Time.now - time_frame_in_days).map do |u|
      [:id, :mkey, :mobile_number, :first_name,:last_name, :email, :status].each_with_object({}) do |attr, memo|
        memo[attr] = u.send attr
      end
    end
  end

  private

  def set_options
    @time_frame_in_days = options['time_frame_in_days'] ? options['time_frame_in_days'].to_i.days : DEFAULT_TIME_FRAME
  end
end
