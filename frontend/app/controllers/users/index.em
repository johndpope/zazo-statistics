class UsersIndexController extends Ember.ArrayController
  query: ''
  userIdOrMkey: ''

  isDataAvailable: ~>
    @model.length > 0
  isSearch: ~>
    @query != ''
  count: ~>
    @model.count
  totalCount: ~>
    @model.totalCount

  findByIdOrMkey: ->
    controller = this
    transitionToUser = (user) ->
      if user.id is undefined
        console.log "user.id is undefined: #{user}"
      else
        controller.transitionToRoute('users.show', user)
    @store.find('user', { user_id_or_mkey: @userIdOrMkey }).then(transitionToUser)

  actions:
    search: ->
      if @userIdOrMkey != ''
        @findByIdOrMkey()
      else
        @model = @store.find('user', { query: @query })
    showUser: ->
      @findByIdOrMkey()

`export default UsersIndexController`
