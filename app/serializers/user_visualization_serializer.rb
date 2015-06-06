class UserVisualizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :mobile_number, :status, :connection_counts,
             :messages_by_last_month, :average_messages_per_day

  def connection_counts
    object.respond_to?(:connection_counts) ? object.connection_counts : 0
  end

  def status
    calculate_messages_count.total > 0 ? 'active' : object.status
  end

  def messages_by_last_month
    calculate_messages_count.total
  end

  def average_messages_per_day
    calculate_messages_count.average
  end

private

  def calculate_messages_count
    unless @average_messages_by_period
      @average_messages_by_period = AverageMessagesByPeriodQuery.new object
      @average_messages_by_period.execute
    end
    @average_messages_by_period
  end
end