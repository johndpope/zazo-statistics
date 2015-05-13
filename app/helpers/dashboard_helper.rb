module DashboardHelper
  def metric_chart(chart, metric, group_by, options = {})
    chartkick_chart chart.to_s.classify, url_for(action: metric, group_by: group_by), options
  end
end
