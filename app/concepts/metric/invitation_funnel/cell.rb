class Metric::InvitationFunnel::Cell < Cell::Concept
  def show
    render self.model.class::TYPE
  end

  private

  def method_missing(method, *)
    self.model.respond_to?(method) ? self.model.send(method) : super
  end
end
