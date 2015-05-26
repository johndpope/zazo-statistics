class Metric < Hashie::Mash
  def grouppable_by_timeframe?
    key?('type') && self['type'] == 'grouppable_by_timeframe'
  end
end
