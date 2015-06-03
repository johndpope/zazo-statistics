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

  settings:
    element: 'visualization'
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
      user:        JSON.parse container.getAttribute 'data-user'
      friends:     JSON.parse container.getAttribute 'data-friends'
      connections: JSON.parse container.getAttribute 'data-connections'
    data.users = data.friends
    data.users.push data.user

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
    _(data.connections).each (conn) =>
      prepare.push {
        from: conn.creator_id
        to: conn.target_id
      } if conn.creator_id != conn.target_id
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

  getUserById: (id) ->
    _(data.users).find (u) -> u.id == parseInt id

(new Zazo.Visualization.SocialGraph()).init()