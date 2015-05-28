class Metric < Hashie::Mash
  def aggregated_by_timeframe?
    key?('type') && self['type'] == 'aggregated_by_timeframe'
  end
end
