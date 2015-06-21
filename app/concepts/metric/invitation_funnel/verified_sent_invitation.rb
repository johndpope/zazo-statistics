class Metric::InvitationFunnel::VerifiedSentInvitation < Metric::InvitationFunnel::Base
  properties total:   'total_verified',
             reduced: 'verified_sent_invitations',
             delay:   'avg_delay_in_hours'
end
