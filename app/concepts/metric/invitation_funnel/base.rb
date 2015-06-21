module Metric::InvitationFunnel
  class Base
    class << self
      attr_accessor :total_key,
                    :reduced_key,
                    :delay_key

      def properties(props)
        self.total_key   = props[:total]
        self.reduced_key = props[:reduced]
        self.delay_key   = props[:delay]
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
  end
end
