class Metric::InvitationFunnel::VerifiedSentInvitation < Metric::InvitationFunnel::RateBase
  properties total:   'total_verified',
             reduced: 'verified_sent_invitations',
             delay:   'avg_delay_in_hours',
             delay_meas: 'hours'

  titles metric_title:  'Invites by Non Marketing Verified Users (NMVs)',
         total_title:   'Total verified',
         reduced_title: 'Verified sent invitations',
         rate_title:    'Invites per NMV',
         delay_title:   'Average delay'
end
