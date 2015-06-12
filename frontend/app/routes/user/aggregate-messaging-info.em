class UserAggregateMessagingInfoRoute extends Ember.Route
  model: (params) ->
    user = @modelFor('user')
    Ember.$.get("/users/#{user.id}/aggregate_messaging_info")

`export default UserAggregateMessagingInfoRoute`
