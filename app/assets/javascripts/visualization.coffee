'use strict'

class SocialGraph

  container = undefined
  network   = undefined
  nodes     = undefined
  edges     = undefined
  data      = undefined

  options   =
    nodes:
      shape: 'dot'
    interaction:
      dragNodes: false
    physics:
      solver: 'hierarchicalRepulsion'

  settings:
    element: 'visualization'
    userKey: 'user_visualization'
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
    data      = JSON.parse container.getAttribute 'data-users'
    @buildNodes()
    @buildNetwork()

  buildNodes: ->
    nodes = new vis.DataSet _(data).map (item) =>
      user = item[@settings.userKey]
      id: user.id
      label: user.name
      size: 25
      color: @colorByStatus user

  buildEdges: ->
    edges = new vis.DataSet [
      { from: 1, to: 3 }
      { from: 1, to: 2 }
      { from: 2, to: 4 }
      { from: 2, to: 5 }
    ]

  buildNetwork: ->
    data =
      nodes: nodes
      edges: edges
    network = new vis.Network container, data, options

  colorByStatus: (user) ->
    color = @settings.statusColor[user.status]
    color = @settings.statusColor.else unless color
    border: 'black'
    background: color

(new SocialGraph()).init()