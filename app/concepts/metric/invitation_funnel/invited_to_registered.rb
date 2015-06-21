class Metric::InvitationFunnel::InvitedToRegistered < Metric::InvitationFunnel::Base
  properties total:   'total_invited',
             reduced: 'invited_that_register',
             delay:   'avg_delay_in_hours'
end
