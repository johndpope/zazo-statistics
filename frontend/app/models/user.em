`import DS from 'ember-data'`

class User extends DS.Model
  first_name: DS.attr('string')
  last_name: DS.attr('string')
  mobile_number: DS.attr('string')
  device_platform: DS.attr('string')
  mkey: DS.attr('string')
  auth: DS.attr('string')
  verification_code: DS.attr('string')
  verification_date_time: DS.attr('date')
  status: DS.attr('string')

  +computed first_name, last_name
  name: ->
    "#{@first_name} #{@last_name}"

`export default User`
