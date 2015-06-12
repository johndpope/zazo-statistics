class UserAggregateMessagingInfoController extends Ember.Controller
  needs: ['user']
  user: Ember.computed.alias("controllers.user.model")

`export default UserAggregateMessagingInfoController`
