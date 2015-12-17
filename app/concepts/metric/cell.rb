class Metric::Cell < Cell::Concept
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper
  include SimpleForm::ActionViewExtensions::FormHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::NumberHelper
  include Chartkick::Helper

  layout :layout
  property :type, :name

  def show
    render '_' + type
  rescue Cell::TemplateMissingError
    render :show
  end

  private

  def title
    name.titleize
  end

  def chart(options = {})
    send type, options
  end

  def metric
    send type
  end

  def chart_id
    "chart-#{SecureRandom.hex}"
  end

  def metric_data(name, options = {})
    @metric_data ||= EventsApi.new.metric_data(name, options)
  end

  def metric_options
    options[:options][type.to_sym] || {} rescue {}
  end

  #
  # metrics
  #

  def aggregated_by_timeframe(options)
    url = url_for(action: :show, id: name, group_by: options[:group_by], only_path: true)
    area_chart url, id: chart_id
  end

  def onboarding_info(*)
    new_data = data.keys.map { |key| { name: key, data: data[key] } }
    line_chart new_data, height: '800px', min: -5, max: 100, id: chart_id
  end

  def invitation_funnel(subject)
    @data ||= metric_data :invitation_funnel, metric_options
    return @data if subject == :raw
    @mapped ||= @data.keys.map do |key|
      klass = "Metric::InvitationFunnel::#{key.classify}".safe_constantize
      klass.nil? ? { name: key, data: @data[key] } : klass.new(@data[key])
    end
  end

  def non_marketing_users_data
    @metric ||= Metric::NonMarketingUsersData.new metric_data(:non_marketing_users_data, metric_options), metric_options
  end

  def upload_duplications(*)
    mkeys = data.map { |i| i['sender_id'] }
    new_data = User.where(mkey: mkeys).group(:device_platform).count
    pie_chart new_data, colors: %w(grey green blue), id: chart_id
  end

  def aggregated(*)
    pie_chart data.except(total_attribute), id: chart_id
  end

  #
  # specific helpers
  #

  def data
    return @data if @data
    @data = metric_data(name)
    @data = @data['data'] if @data.kind_of?(Hash) && @data.key?('data')
    @data
  end

  def total_attribute
    @metric_data['meta']['total']
  end
end
