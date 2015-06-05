class UsersIndexController extends Ember.ArrayController
  +computed model
  isDataAvailable: ->
    @model.length > 0

`export default UsersIndexController`
