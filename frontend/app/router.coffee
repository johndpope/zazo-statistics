`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

Router.map ->
  this.route 'users', ->
    this.route 'index', path: '/'
    this.route 'show', path: '/:id'

`export default Router`
