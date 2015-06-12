class UsersRoute extends Ember.Route
  model: (params) ->
    @store.find 'user', params
  setupController: (controller, model) ->
    if Ember.isPresent(controller.query)
      controller.term = controller.query
      controller.search()
    else
      @_super(controller, model)

`export default UsersRoute`
