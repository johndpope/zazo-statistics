class Metric::InvitationFunnel::RegisteredToVerified < Metric::InvitationFunnel::RateBase
  properties total:   'total_registered',
             reduced: 'registered_that_verify',
             delay:   'avg_delay_in_minutes',
             delay_meas: 'minutes'

  titles metric_title:  'Registered (non marketing) becoming verified',
         total_title:   'Total registered',
         reduced_title: 'Registered that verified',
         rate_title:    'Becoming verified rate',
         delay_title:   'Average delay'
end
