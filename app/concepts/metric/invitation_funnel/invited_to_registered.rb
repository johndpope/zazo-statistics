class Metric::InvitationFunnel::InvitedToRegistered < Metric::InvitationFunnel::RateBase
  properties total:   'total_invited',
             reduced: 'invited_that_register',
             delay:   'avg_delay_in_hours',
             delay_meas: 'hours'

  titles metric_title:  'Invited becoming registered',
         total_title:   'Total invited',
         reduced_title: 'Invited that registered',
         rate_title:    'Becoming registered rate',
         delay_title:   'Average delay'
end
