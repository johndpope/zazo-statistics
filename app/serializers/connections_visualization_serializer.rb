class ConnectionsVisualizationSerializer
  ATTRIBUTES = [:creator_id, :target_id, :outgoing_count, :incoming_count]

  def initialize(connections, options)
    @connections = connections
    @options     = options
  end

  def serialize
    @connections.each_with_object([]) do |conn, memo|
      memo << serialize_connection(conn)
    end
  end

private

  def serialize_connection(conn)
    ATTRIBUTES.each_with_object({}) do |attr, memo|
      memo[attr] = respond_to?("connection_#{attr}", true) ?
          send("connection_#{attr}", conn) : conn.send(attr)
    end
  end

  #
  # Custom and redefined attributes
  #

  def connection_outgoing_count(conn)
    get_outgoing_or_incoming_count conn, :outgoing
  end

  def connection_incoming_count(conn)
    get_outgoing_or_incoming_count conn, :incoming
  end

  #
  # Attributes helpers
  #

  def get_outgoing_or_incoming_count(conn, key)
    order = %w{ sender receiver }
    order.reverse! if key == :incoming
    result = @options[:counts].find do |r|
      r[order.first] == conn.creator.event_id &&
      r[order.last]  == conn.target.event_id
    end
    result ? result['count'].to_i : 0
  end
end
