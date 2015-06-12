class UserRoute extends Ember.Route
  model: (params)->
    @store.find('user', params.user_id)

`export default UserRoute`
