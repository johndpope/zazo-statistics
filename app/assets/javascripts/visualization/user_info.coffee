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
    <li>Circle: <%= circle %> friends</li>
    <li>Last month: <%= total %> msg</li>
    <li>Per day: <%= average %> msg</li>
  "

  settings:
    element: 'user-info'

  show: (user, position) ->
    @container.innerHTML = @template
      id:      user.id
      name:    user.name
      mobile:  user.mobile_number
      circle:  user.connection_counts
      total:   user.messages_by_last_month
      average: user.average_messages_per_day
    @showContainer position

  showContainer: (position) ->
    @container.style.left = "#{position.x}px"
    @container.style.top  = "#{position.y}px"
    @container.style.display = 'block'

  hide: ->
    @container.style.display = 'none'
