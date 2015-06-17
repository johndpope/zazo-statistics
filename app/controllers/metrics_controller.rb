class MetricsController < AdminController
  before_action :validate_group_by, only: [:show]

  def index
    @metrics = events_api.metric_list
    @metrics.is_a?(Array) && @metrics.select! do |m|
      %w(active_users messages_sent usage_by_active_users).include?(m['name'])
    end.map! { |m| Metric.new(m) }
  end

  def show
    events_metric params[:id]
  end

  private

  def events_metric(metric)
    render json: events_api.metric_data(metric, group_by: @group_by)
  end

  def validate_group_by
    @group_by = params[:group_by].try(:to_sym) || :day
    @group_by.in?(Groupdate::FIELDS) || render_error("invalid group_by value: #{@group_by.inspect}, valid fields are #{Groupdate::FIELDS}")
  end
end
