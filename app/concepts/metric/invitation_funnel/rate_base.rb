module Metric::InvitationFunnel
  class RateBase
    TYPE = :rate_base

    class << self
      attr_accessor :total_key, :reduced_key, :delay_key,
                    :delay_meas, :metric_title, :total_title,
                    :reduced_title, :rate_title, :delay_title

      def properties(props)
        self.total_key   = props[:total]
        self.reduced_key = props[:reduced]
        self.delay_key   = props[:delay]
        self.delay_meas  = props[:delay_meas]
      end

      def titles(props)
        self.metric_title  = props[:metric_title]
        self.total_title   = props[:total_title]
        self.reduced_title = props[:reduced_title]
        self.rate_title    = props[:rate_title]
        self.delay_title   = props[:delay_title]
      end
    end

    def initialize(data)
      @data = data
    end

    def total
      @data[self.class.total_key].to_i
    end

    def reduced
      @data[self.class.reduced_key].to_i
    end

    def rate
      (reduced * 100.0 / total).round 2
    end

    def delay
      @data[self.class.delay_key]
    end

    def method_missing(method, *)
      self.class.respond_to?(method) ? self.class.send(method) : super
    end

    def respond_to?(method, *)
      self.class.public_methods.include?(method) || super
    end
  end
end
