class UsersIndexRoute extends Ember.Route
  model: ->
    @store.findAll('user')

`export default UsersIndexRoute`
