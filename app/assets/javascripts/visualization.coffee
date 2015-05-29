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

  constructor: ->

  init: ->
    container = document.getElementById @settings.element
    data      = JSON.parse container.getAttribute 'data-users'
    @buildNodes()
    @buildNetwork()

  buildNodes: ->
    nodes = new vis.DataSet _(data).map (item) ->
      user = item.user
      id: user.id
      label: user.name
      size: 25

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

(new SocialGraph()).init()