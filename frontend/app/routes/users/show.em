class UserShowRoute extends Ember.Route
  model: (params)->
    @store.find('user', params.id)


`export default UserShowRoute`
