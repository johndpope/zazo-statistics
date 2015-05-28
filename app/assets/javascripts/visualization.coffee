'use strict'

nodes = new vis.DataSet [
  { id: 1, label: 'Node 1', font: { size: 24 } }
  { id: 2, label: 'Node 2' }
  { id: 3, label: 'Node 3' }
  { id: 4, label: 'Node 4' }
  { id: 5, label: 'Node 5' }
]

edges = new vis.DataSet [
  { from: 1, to: 3 }
  { from: 1, to: 2 }
  { from: 2, to: 4 }
  { from: 2, to: 5 }
]

container = document.getElementById 'visualization'

data =
  nodes: nodes
  edges: edges

options =
  nodes:
    shape: 'circle'

network = new vis.Network container, data, options