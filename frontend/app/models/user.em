`import DS from 'ember-data'`

class User extends DS.Model
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  mobileNumber: DS.attr('string')
  devicePlatform: DS.attr('string')
  mkey: DS.attr('string')
  auth: DS.attr('string')
  verificationCode: DS.attr('string')
  verificationDateTime: DS.attr('date')
  status: DS.attr('string')

  +computed firstName, lastName
  name: ->
    "#{@firstName} #{@lastName}"

`export default User`
