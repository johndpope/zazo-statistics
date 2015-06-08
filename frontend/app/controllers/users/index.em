class UsersIndexController extends Ember.ArrayController
  query: ''

  isDataAvailable: ~>
    @model.length > 0

  isSearch: ~>
    @query != ''

  actions:
    search: ->
      console.log "search: #{@query}"
      @model = @store.find('user', { query: @query })

`export default UsersIndexController`
