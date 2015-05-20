module MetricsHelper
  def events_metric_chart(chart, metric, group_by, options = {})
    chartkick_chart chart.to_s.classify, url_for(action: :show, id: metric, group_by: group_by), options
  end
end
