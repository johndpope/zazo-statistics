class UsersIndexRoute extends Ember.Route
  model: (params) ->
    @store.find 'user', params

`export default UsersIndexRoute`
