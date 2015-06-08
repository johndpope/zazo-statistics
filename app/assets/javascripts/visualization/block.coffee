'use strict'

class Zazo.Visualization.Block

  constructor: (parent) ->
    @template  = _.template @template
    @createContainer parent

  createContainer: (parent) ->
    @container = document.createElement 'div'
    @container.setAttribute 'id', @settings.element
    parent.appendChild @container
