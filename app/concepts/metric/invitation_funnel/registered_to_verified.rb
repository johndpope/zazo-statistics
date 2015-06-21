class Metric::InvitationFunnel::RegisteredToVerified < Metric::InvitationFunnel::Base
  properties total:   'total_registered',
             reduced: 'registered_that_verify',
             delay:   'avg_delay_in_minutes'
end
