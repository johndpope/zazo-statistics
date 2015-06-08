class AverageMessagesByPeriodQuery
  DEFAULT_SINCE  = Date.today - 1.month
  DEFAULT_PERIOD = 'day'

  attr_accessor :total, :average

  def initialize(user, options={})
    @user   = user
    @period = options[:period] || DEFAULT_PERIOD
    @since  = options[:since]  || DEFAULT_SINCE
    @total, @average = 0, 0
  end

  def execute
    @user.name
    if @user.status == 'verified'
      data = EventsApi.new.metric_data :messages_count_by_period,
                                       user_id:  @user.mkey,
                                       group_by: @period,
                                       since:    @since
      calculate_total_and_average data
    end
  end

private

  def calculate_total_and_average(data)
    if data.size > 0
      data.keys.each { |date| @total += data[date] }
      days_between = (Date.today - Date.parse(data.keys.first)).round
      @average = (@total.to_f / days_between).round 2
    end
  end
end
