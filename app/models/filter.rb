module Filter
  class UnknownFilter < StandardError
  end

  def self.find(name)
    const_get name.to_s.camelize
  rescue NameError
    raise UnknownFilter, "Filter #{name.inspect} not found"
  end

  def self.all
    Filter::Base.descendants.select { |klass| klass.name.starts_with?("#{name}::") }.sort_by(&:name)
  end
end
