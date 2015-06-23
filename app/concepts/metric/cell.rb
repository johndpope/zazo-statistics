class Metric::Cell < Cell::Concept
  include Chartkick::Helper

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
    EventsApi.new.metric_data(name)
  end

  def aggregated_by_timeframe(options)
    area_chart url_for(action: :show, id: name, group_by: options[:group_by], only_path: true),
               id: chart_id
  end

  def onboarding_info(*)
    data = metric_data :onboarding_info
    data = data.keys.map { |key| { name: key, data: data[key] } }
    line_chart data, height: '800px', min: -5, max: 100, id: chart_id
  end

  def invitation_funnel(*)
    data = metric_data :invitation_funnel
    data.keys.map do |key|
      klass = "Metric::InvitationFunnel::#{key.classify}".safe_constantize
      klass.nil? ? { name: key, data: data[key] } : klass.new(data[key])
    end
  end

  def upload_duplications(*)
    raw_data = metric_data :upload_duplications
    mkeys = raw_data.map { |i| i['sender_id'] }
    data = User.where(mkey: mkeys).group(:device_platform).count
    pie_chart data, colors: ['grey', 'green', 'blue'], id: chart_id
  end
end
