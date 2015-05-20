module DashboardHelper
  def metric_chart(chart, metric, options = {})
    chartkick_chart chart.to_s.classify, url_for(action: metric), options
  end
end
