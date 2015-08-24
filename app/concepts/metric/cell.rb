class Metric::Cell < Cell::Concept
  include Chartkick::Helper
  include ActionView::Helpers::NumberHelper

  layout :layout
  property :type
  property :name

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

  def chart_id
    "chart-#{SecureRandom.hex}"
  end

  def metric_data(name)
    @metric_data ||= EventsApi.new.metric_data(name)
  end

  def data
    return @data if @data
    @data = metric_data(name)
    @data.key?('data') && @data = @data['data']
    @data
  end

  def total_attribute
    @metric_data['meta']['total']
  end

  def aggregated_by_timeframe(options)
    area_chart url_for(action: :show, id: name, group_by: options[:group_by], only_path: true),
               id: chart_id
  end

  def onboarding_info(*)
    new_data = data.keys.map { |key| { name: key, data: data[key] } }
    line_chart new_data, height: '800px', min: -5, max: 100, id: chart_id
  end

  def invitation_funnel(subject)
    @data ||= metric_data :invitation_funnel
    return @data if subject == :raw
    @mapped ||= @data.keys.map do |key|
      klass = "Metric::InvitationFunnel::#{key.classify}".safe_constantize
      klass.nil? ? { name: key, data: @data[key] } : klass.new(@data[key])
    end
  end

  def upload_duplications(*)
    mkeys = data.map { |i| i['sender_id'] }
    new_data = User.where(mkey: mkeys).group(:device_platform).count
    pie_chart new_data, colors: ['grey', 'green', 'blue'], id: chart_id
  end

  def aggregated(*)
    pie_chart data.except(total_attribute), id: chart_id
  end
end
