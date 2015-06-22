class Metric::InvitationFunnel::VerifiedSentInvitation < Metric::InvitationFunnel::RateBase
  properties total:   'total_verified',
             reduced: 'verified_sent_invitations',
             delay:   'avg_delay_in_hours',
             delay_meas: 'hours'

  titles metric_title:  'Verified (non marketing) sent invitations',
         total_title:   'Total verified',
         reduced_title: 'Verified sent invitations',
         rate_title:    'Sent invitations rate',
         delay_title:   'Average delay'
end
