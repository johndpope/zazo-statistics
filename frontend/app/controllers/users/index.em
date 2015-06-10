class UsersIndexController extends Ember.ArrayController
  queryParams: ['query']
  query: ''
  term: ''
  userIdOrMkey: ''

  isDataAvailable: ~>
    @model.length > 0
  isSearch: ~>
    Ember.isPresent(@term)
  meta: ~>
    @store.metadataFor('user')
  title: ~>
    count = @meta*.count
    totalCount = @meta*.total_count
    if @isSearch
      Ember.String.htmlSafe "Search results for <strong>#{@term}</strong> (listed #{count} records of #{totalCount} total)"
    else
      Ember.String.htmlSafe "Listed #{count} records of #{totalCount} total"
  gotoUser: ->
    controller = this
    transitionToUser = (user) ->
      controller.userIdOrMkey = ''
      controller.transitionToRoute('users.show', user)
    @store.find('user', @userIdOrMkey).then(transitionToUser)
  search: (term) ->
    @model = @store.find('user', { query: @query })
  actions:
    search: ->
      if Ember.isPresent(@userIdOrMkey)
        @gotoUser()
      else
        @query = @term
        @search()

`export default UsersIndexController`
