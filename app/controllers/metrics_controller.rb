class MetricsController < AdminController
  before_action :validate_group_by, only: [:show]

  def index
    @metrics = events_api.metric_list
    if @metrics.is_a?(Array)
      @metrics = @metrics.map { |m| Metric.new(m) }.select(&:grouppable_by_timeframe?)
    end
  end

  def show
    events_metric params[:id]
  end

  private

  def events_api
    EventsApi.new
  end

  def events_metric(metric)
    render json: events_api.metric_data(metric, group_by: @group_by)
  end

  def validate_group_by
    @group_by = params[:group_by].try(:to_sym) || :day
    @group_by.in?(Groupdate::FIELDS) || render_error("invalid group_by value: #{@group_by.inspect}, valid fields are #{Groupdate::FIELDS}")
  end
end
