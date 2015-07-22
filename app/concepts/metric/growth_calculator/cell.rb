class Metric::GrowthCalculator::Cell < Cell::Concept
  def show
    render
  end

  private

  def nmv_sent_invite_rate
    count = model['verified_sent_invitations']['verified_sent_invitations'].to_f
    total = model['verified_sent_invitations']['total_verified'].to_f
    (count / total * 100).round 2
  end
end
