module MetricsHelper
  UNIQUE = %(onboarding_info)

  def events_metric_chart(chart, metric, group_by, options = {})
    chartkick_chart chart.to_s.classify, url_for(action: :show, id: metric, group_by: group_by), options
  end

  def onboarding_info_chart
    data = EventsApi.new.metric_data :onboarding_info
    data = data.keys.map do |key|
      { name: key, data: data[key] }
    end
    line_chart data, height: '800px', min: -5, max: 100
  end
end
