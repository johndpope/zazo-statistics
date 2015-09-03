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

  #
  # metrics
  #

  def aggregated_by_timeframe(options)
    prepared_data = fetch_data(options[:group_by]) { metric_data name, options }
    area_chart prepared_data, id: chart_id
  end

  def onboarding_info(*)
    prepared_data = fetch_data { data.keys.map { |key| { name: key, data: data[key] } } }
    line_chart prepared_data, height: '800px', min: -5, max: 100, id: chart_id
  end

  def invitation_funnel(subject)
    postfix = "s_#{metric_options[:start_date]}-e_#{metric_options[:end_date]}"
    @data ||= fetch_data(postfix) { metric_data :invitation_funnel, metric_options }
    return @data if subject == :raw
    @mapped ||= @data.keys.map do |key|
      klass = "Metric::InvitationFunnel::#{key.classify}".safe_constantize
      klass.nil? ? { name: key, data: @data[key] } : klass.new(@data[key])
    end
  end

  def upload_duplications(*)
    prepared_data = fetch_data { User.where(mkey: data.map { |i| i['sender_id'] }).group(:device_platform).count }
    pie_chart prepared_data, colors: %w(grey green blue), id: chart_id
  end

  def aggregated(*)
    pie_chart (fetch_data { data.except(total_attribute) }), id: chart_id
  end

  def rate_line_chart(*)
    line_chart [{ name: 'rate', data: fetch_data { data } }], height: '500px', id: chart_id
  end

  #
  # specific helpers
  #

  def data(options = {})
    return @data if @data
    @data = metric_data name, options
    @data = @data['data'] if @data.key?('data')
    @data
  end

  def total_attribute
    @metric_data['meta']['total']
  end

  def chart_id
    "chart-#{SecureRandom.hex}"
  end

  def metric_data(name, options = {})
    @metric_data = EventsApi.new.metric_data(name, options)
  end

  def metric_options
    options[:options][type.to_sym]
  rescue NoMethodError
    Hash.new
  end

  #
  # caching
  #

  def fetch_data(postfix = nil)
    metric = postfix ? "#{name}-#{postfix}" : name
    metric_data = Metric::Caching.fetch metric
    unless metric_data
      metric_data = yield
      Metric::Caching.save metric, metric_data
    end
    metric_data
  end
end
