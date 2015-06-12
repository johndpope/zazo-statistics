`import config from './config/environment'`

class Router extends Ember.Router
  location: config.locationType

Router.map ->
  @resource 'users'
  @resource 'user', path: 'users/:user_id', ->
    @route 'aggregate-messaging-info'

`export default Router`
