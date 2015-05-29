'use strict'

class SocialGraph

  container = undefined
  network   = undefined
  nodes     = undefined
  edges     = undefined
  data      = undefined
  temp      =
    nodes: []
    edges: {}
    connections: []
  options   =
    nodes:
      shape: 'dot'

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
    @buildEdges()
    @buildNetwork()

  buildNodes: ->
    nodes = new vis.DataSet _(data).map (item) =>
      user = item[@settings.userKey]
      temp.connections.push user.connections
      temp.nodes[user.id] = true
      id: user.id
      label: user.name
      size: 25
      color: @colorByStatus user

  buildEdges: ->
    prepare = []
    _(temp.connections).each (userConnections) =>
      _(userConnections).each (conn) =>
        c_id = conn.creator_id
        t_id = conn.target_id
        if @isNodesExists(c_id, t_id) &&
           @isConnectionFit(c_id, t_id)
          temp.edges["#{c_id}:#{t_id}"] = true
          prepare.push
            from: c_id
            to: t_id
    edges = new vis.DataSet prepare

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

  isNodesExists: (creator, target) ->
    temp.nodes[creator] && temp.nodes[target]

  isConnectionFit: (creator, target) ->
    if creator == target
      false
    else
      !(temp.edges["#{creator}:#{target}"] ||
        temp.edges["#{target}:#{creator}"])

(new SocialGraph()).init()