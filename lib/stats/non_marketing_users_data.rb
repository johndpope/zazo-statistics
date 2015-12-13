#results = [
#  {"inviter"=>"ldvN1o2jzhw0KbYQZJTX", "invites_sent"=>"0", "is_verified"=>"t", "is_registered"=>"t"},
#  {"inviter"=>"1Csuhw7LL9QTNQ43FdB9", "invites_sent"=>"10", "is_verified"=>"t", "is_registered"=>"t"}
#]

results = EventsApi.new.metric_data 'non_marketing_users_data'
users = User.where(mkey: results.map { |row| row['inviter'] }).each_with_object({}) do |user, memo|
  memo[user.mkey] = user.device_platform.to_s
end

total_invites = { total: 0, android: 0, ios: 0 }
nmv = { total: 0, android: 0, ios: 0 }
nmr = { total: 0, android: 0, ios: 0 }
nmv_more_then_zero_invites = { total: 0, android: 0, ios: 0 }

results.each do |row|
  platform = users[row['inviter']]
  invites  = row['invites_sent'].to_i
  next unless platform

  total_invites[:total]   += invites
  total_invites[:android] += invites if platform == 'android'
  total_invites[:ios]     += invites if platform == 'ios'

  if row['is_verified'] == 't'
    nmv[:total]   += 1
    nmv[:android] += 1 if platform == 'android'
    nmv[:ios]     += 1 if platform == 'ios'

    if invites > 0
      nmv_more_then_zero_invites[:total]   += 1
      nmv_more_then_zero_invites[:android] += 1 if platform == 'android'
      nmv_more_then_zero_invites[:ios]     += 1 if platform == 'ios'
    end
  end

  if row['is_registered'] == 't'
    nmr[:total]   += 1
    nmr[:android] += 1 if platform == 'android'
    nmr[:ios]     += 1 if platform == 'ios'
  end
end

stat_1_android = nmv_more_then_zero_invites[:android].to_f / nmv[:android]
stat_1_ios     = nmv_more_then_zero_invites[:ios].to_f     / nmv[:ios]

stat_2_android = total_invites[:android].to_f / nmv_more_then_zero_invites[:android]
stat_2_ios     = total_invites[:ios].to_f     / nmv_more_then_zero_invites[:ios]

stat_3_total   = (nmr[:android] + nmr[:ios]).to_f / (total_invites[:android] + total_invites[:ios])
stat_3_devices = nmr[:total].to_f / total_invites[:total]

stat_4_android = nmv[:android].to_f / nmr[:android]
stat_4_ios     = nmv[:ios].to_f     / nmr[:ios]

p stat_1_android: stat_1_android, stat_1_ios: stat_1_ios,
  stat_2_android: stat_2_android, stat_2_ios: stat_2_ios,
  stat_3_total:   stat_3_total,   stat_3_devices: stat_3_devices,
  stat_4_android: stat_4_android, stat_4_ios: stat_4_ios
