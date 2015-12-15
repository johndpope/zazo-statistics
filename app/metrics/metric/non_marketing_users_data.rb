class Metric::NonMarketingUsersData
  VERIFIED_DATE_FROM = '2015-11-04'

  attr_reader :data
  attr_reader :total_invites, :nmv, :nmr, :nmv_more_then_zero_invites, :app_link_clicks

  def initialize(data)
    @data = data

    @total_invites = initial_stats.merge android_after_verified_date: 0
    @nmv = initial_stats
    @nmr = initial_stats
    @nmv_more_then_zero_invites = initial_stats
    @app_link_clicks = 0

    calculate_results
  end

  def nmv_more_then_zero_invites_from_nmv(platform)
    (nmv_more_then_zero_invites[platform].to_f / nmv[platform]).round(4)
  end

  def total_invites_from_nmv_more_then_zero_invites(platform)
    (total_invites[platform].to_f / nmv_more_then_zero_invites[platform]).round(4)
  end

  def click_store_link_from_total_invites
    (app_link_clicks.to_f / total_invites[:android_after_verified_date]).round(4)
  end

  def nmr_from_total_invites
    (nmr[:total].to_f / total_invites[:total]).round(4)
  end

  def nmv_from_nmr(platform)
    (nmv[platform].to_f / nmr[platform]).round(4)
  end

  private

  def initial_stats
    { total: 0, android: 0, ios: 0 }
  end

  def users_with_platform
    User.where(mkey: data.map { |row| row['inviter'] }).each_with_object({}) do |user, memo|
      memo[user.mkey] = user.device_platform.to_s
    end
  end

  def calculate_results
    users = users_with_platform
    data.each do |row|
      platform = users[row['inviter']]
      invites  = row['invites_sent'].to_i
      next unless platform

      @total_invites[:total]   += invites
      @total_invites[:android] += invites if platform == 'android'
      @total_invites[:ios]     += invites if platform == 'ios'

      if row['is_verified'] == 't'
        @nmv[:total]   += 1
        @nmv[:android] += 1 if platform == 'android'
        @nmv[:ios]     += 1 if platform == 'ios'

        if invites > 0
          @nmv_more_then_zero_invites[:total]   += 1
          @nmv_more_then_zero_invites[:android] += 1 if platform == 'android'
          @nmv_more_then_zero_invites[:ios]     += 1 if platform == 'ios'
        end

        if platform == 'android' && row['becoming_verified'] &&
          Time.parse(row['becoming_verified']) >= Time.parse(VERIFIED_DATE_FROM)
          @total_invites[:android_after_verified_date] += invites
          @app_link_clicks += row['link_clicks'].to_i
        end
      end

      if row['is_registered'] == 't'
        @nmr[:total]   += 1
        @nmr[:android] += 1 if platform == 'android'
        @nmr[:ios]     += 1 if platform == 'ios'
      end
    end
  end
end
