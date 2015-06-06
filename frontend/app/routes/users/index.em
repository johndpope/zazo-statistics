class UsersIndexRoute extends Ember.Route
  model: ->
    @store.find('user')

`export default UsersIndexRoute`
