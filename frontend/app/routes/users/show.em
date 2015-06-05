class UserShowRoute extends Ember.Route
  model: ->
    @store.find('user', params.id)


`export default UserShowRoute`
