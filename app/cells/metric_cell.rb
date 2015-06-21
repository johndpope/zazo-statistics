class MetricCell < Cell::ViewModel
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

  def aggregated_by_timeframe(options)
    area_chart url_for(action: :show, id: name, group_by: options[:group_by], only_path: true),
               id: chart_id
  end

  def onboarding_info(*)
    data = EventsApi.new.metric_data :onboarding_info
    data = data.keys.map { |key| { name: key, data: data[key] } }
    line_chart data, height: '800px', min: -5, max: 100, id: chart_id
  end

  def invitation_funnel(*)
    EventsApi.new.metric_data :invitation_funnel
  end

  def chart_id
    "chart-#{SecureRandom.hex}"
  end
end
