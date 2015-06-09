class UsersIndexController extends Ember.ArrayController
  query: ''
  userIdOrMkey: ''

  isDataAvailable: ~>
    @model.length > 0
  isSearch: ~>
    Ember.isPresent(@query)
  meta: ~>
    @store.metadataFor('user')

  count: Ember.computed.alias('meta.count')
  totalCount: Ember.computed.alias('meta.total_count')

  gotoUser: ->
    controller = this
    transitionToUser = (user) ->
      controller.transitionToRoute('users.show', user)
    onFailure = (response) ->
      alert(response.statusText)
    @store.find('user', @userIdOrMkey).then(transitionToUser, onFailure)

  actions:
    search: ->
      if Ember.isPresent(@userIdOrMkey)
        @gotoUser()
      else
        @model.content = @store.find('user', { query: @query })

`export default UsersIndexController`
