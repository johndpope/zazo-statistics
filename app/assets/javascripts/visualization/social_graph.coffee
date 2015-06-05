'use strict'

class Zazo.Visualization.SocialGraph

  container = undefined
  network   = undefined
  nodes     = undefined
  edges     = undefined
  userInfo  = undefined
  data      = {}

  options   =
    nodes:
      shape: 'dot'
    edges:
      font:
        strokeColor: '#AEAEAE'
        size: 10
      color:
        color: '#AEAEAE'

  tmp =
    maxMsgCount: 0

  settings:
    element: 'visualization'
    maxEdgeWidth: 10
    minEdgeWidth: 1
    statusColor:
      initialized: '#EA9999'
      invited:     '#EA9999'
      registered:  '#FFE599'
      verified:    '#6D9EEB'
      active:      '#93C47D'
      else:        '#C7C7C7'

  constructor: ->

  init: ->
    container = document.getElementById @settings.element

    data =
      target:      JSON.parse container.getAttribute 'data-target'
      users:       JSON.parse container.getAttribute 'data-users'
      connections: JSON.parse container.getAttribute 'data-connections'

    @buildNodes()
    @buildEdges()
    @buildNetwork()
    @initEvents()
    @showLegend()
    @initUserInfo()

  initUserInfo: ->
    userInfo  = new Zazo.Visualization.UserInfo container

  showLegend: ->
    legend = new Zazo.Visualization.LegendColor container
    legend.show @settings.statusColor

  buildNodes: ->
    nodes = new vis.DataSet _(data.users).map (user) =>
      id: user.id
      label: user.name
      size: 25
      color: @colorByStatus user

  buildEdges: ->
    prepare = []
    tmp.maxMsgCount = @calculateMaxMsgCount()
    _(data.connections).each (conn) =>
      if conn.creator_id != conn.target_id
        prepare.push @paramsByConnection conn
    edges = new vis.DataSet prepare

  buildNetwork: ->
    network = new vis.Network container, {
      nodes: nodes
      edges: edges
    }, options

  initEvents: ->
    network.on 'select', (e) =>
      if e.nodes.length == 1
        userInfo.show @getUserById(e.nodes[0]), e.pointer.DOM
      else
        userInfo.hide()

  colorByStatus: (user) ->
    color = @settings.statusColor[user.status]
    color = @settings.statusColor.else unless color
    border: 'black'
    background: color

  paramsByConnection: (conn) ->
    totalMessages = conn.incoming_count + conn.outgoing_count
    arrowsTo   = conn.incoming_count < conn.outgoing_count
    arrowsFrom = conn.incoming_count > conn.outgoing_count

    from: conn.creator_id
    to: conn.target_id
    label: totalMessages

    width: @calculateEdgeWidth totalMessages

  calculateMaxMsgCount: ->
    _(data.connections).reduce (max, conn) ->
      current = conn.incoming_count + conn.outgoing_count
      if current > max
        current
      else
        max
    , 0

  calculateEdgeWidth: (totalMessages) ->
    result = +((totalMessages / tmp.maxMsgCount) * @settings.maxEdgeWidth)
    result = @settings.minEdgeWidth if result < @settings.minEdgeWidth
    result

  getUserById: (id) ->
    _(data.users).find (u) -> u.id == parseInt id