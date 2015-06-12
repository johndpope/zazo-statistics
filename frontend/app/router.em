`import config from './config/environment'`

class Router extends Ember.Router
  location: config.locationType

Router.map ->
  @resource 'users', ->
    @route 'index', path: '/'
    @route 'show', path: '/:id'

`export default Router`
