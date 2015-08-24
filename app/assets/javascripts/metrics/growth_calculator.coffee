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
    growthDurationInDays    = 365

  setCallbacks = ->
    $('.x-submit').click =>
      resetData()
      setVariables()
      console.log @calculateGrowth()
      drawChart chartData

  drawChart = (data) ->
    chart = new Chartkick.LineChart 'growth-chart', [{
      name: 'growth rate',
      data: data
    }], {
      discrete: true,
      library: { hAxis: { textPosition: 'none' } }
    }

  #
  # public
  #

  init: ->
    #
    setVariables()
    setCallbacks.call(@)

  calculateGain: ->
    nmvSentInviteRate * totalInvitesPerNmv *
    invitedToRegisteredRate * nmrToNmvRate

  calculateGrowth: ->
    gain   = @calculateGain()
    return nmv if gain < 1
    period = Math.round growthDurationInDays / delayInDays
    for i in [1..period]
      invitees *= gain
      nmv      += invitees
      chartData[i] = Math.round nmv
    nmv

  result: ->
    [nmv, invitees]
