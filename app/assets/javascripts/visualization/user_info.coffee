'use strict'

class Zazo.Visualization.UserInfo extends Zazo.Visualization.Block

  template: "
    <li>
      <a href='/users/<%= id %>'>Show</a> /
      <a href='/users/<%= id %>/visualization'>
        Visualize
      </a>
    </li>
    <li>Name:   <%= name %></li>
    <li>Mobile: <%= mobile %></li>
    <li>Status: <%= status %></li>
    <li>Circle: <%= circle %> users</li>
  "

  settings:
    element: 'user-info'

  show: (user, position) ->
    @container.innerHTML = @template {
      id:     user.id
      name:   user.name
      mobile: user.mobile_number
      status: user.status
      circle: user.connection_counts
    }
    @showContainer position

  showContainer: (position) ->
    @container.style.left = "#{position.x}px"
    @container.style.top  = "#{position.y}px"
    @container.style.display = 'block'

  hide: ->
    @container.style.display = 'none'