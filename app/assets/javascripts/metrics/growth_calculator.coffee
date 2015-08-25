'use strict'

class Zazo.Metrics.GrowthCalculator

  #
  # private
  #

  nmvSentInviteRate       = null
  totalInvitesPerNmv      = null
  invitedToRegisteredRate = null
  nmrToNmvRate            = null
  delayInDays             = null
  growthDurationInDays    = null

  nmv       = 0
  gain      = 0
  invitees  = 0
  chart     = null
  chartData = new Object()

  resetData = ->
    nmv      = 1
    invitees = 1
    chartData = new Object()

  setVariables = ->
    nmvSentInviteRate       = parseFloat($('.x-nmv_sent_invite_rate').val())
    totalInvitesPerNmv      = parseFloat($('.x-total_invites_per_nmv').val())
    invitedToRegisteredRate = parseFloat($('.x-invited_to_registered_rate').val())
    nmrToNmvRate            = parseFloat($('.x-nmr_to_nmv_rate').val())
    delayInDays             = parseFloat($('.x-delay_in_days').val())
    growthDurationInDays    = parseInt($('.x-growth_duration_in_days').val()) || 365

  setCallbacks = ->
    $('.x-submit').click =>
      resetData()
      setVariables()
      @calculateGrowth()
      setViralIndex()
      @showResults()

  drawChart = (data) ->
    chart = new Chartkick.LineChart 'x-growth_chart', [{
      name: 'growth rate',
      data: data
    }], {
      discrete: true,
      library: { hAxis: { textPosition: 'none' } }
    }

  showNoGrowth = ->
    $('#x-growth_chart').html '<p class="status_no_growth">No Growth</p>'

  setViralIndex = ->
    $('.x-viral_index').html gain.toFixed(4)

  #
  # public
  #

  init: ->
    setVariables()
    setCallbacks.call(@)
    @calculateGrowth()
    setViralIndex()
    @showResults()

  calculateGain: ->
    nmvSentInviteRate * totalInvitesPerNmv *
    invitedToRegisteredRate * nmrToNmvRate

  calculateGrowth: ->
    gain = @calculateGain()
    return nmv if gain < 1
    period = Math.round growthDurationInDays / delayInDays
    for i in [1..period]
      invitees *= gain
      nmv      += invitees
      chartData[i] = Math.round nmv
    nmv

  showResults: ->
    if gain < 1
      showNoGrowth()
    else
      drawChart(chartData)

  result: ->
    [nmv, invitees]
