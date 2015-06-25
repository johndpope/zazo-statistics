class Metric::InvitationFunnel::VerifiedSentInvitation < Metric::InvitationFunnel::RateBase
  TYPE = :rate_base_invitations

  properties total:   'total_verified',
             reduced: 'verified_sent_invitations',
             delay:   'avg_delay_in_hours',
             delay_meas: 'hours'

  titles metric:  'Invites by NMVs',
         total:   'Total NMVs',
         reduced: 'NMVs sent invitations',
         rate:    'Invites per NMV',
         delay:   'Average delay',
         no_invite:               'NMV no invite',
         no_invite_six_weeks_old: 'NMV > 6w no invite'

  def no_invite
    reduced_with_rate @data['verified_not_invite'].to_i
  end

  def no_invite_six_weeks_old
    reduced_with_rate @data['verified_not_invite_more_6_weeks_old'].to_i
  end
end
