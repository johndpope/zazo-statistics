'use strict'

class SocialGraph

  container = undefined
  network   = undefined
  nodes     = undefined
  edges     = undefined
  options   =
    nodes:
      shape: 'circle'

  settings:
    element: 'visualization'

  constructor: ->

  init: ->
    container = document.getElementById @settings.element
    @buildNodes()
    @buildEdges()
    @buildNetwork()

  buildNodes: ->
    nodes = new vis.DataSet [
      { id: 1, label: 'Node 1', font: { size: 24 } }
      { id: 2, label: 'Node 2' }
      { id: 3, label: 'Node 3' }
      { id: 4, label: 'Node 4' }
      { id: 5, label: 'Node 5' }
    ]

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