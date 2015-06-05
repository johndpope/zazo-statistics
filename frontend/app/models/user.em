`import DS from 'ember-data'`

class User extends DS.Model
  id: DS.attr('integer')
  firstName: DS.attr('string')
  lastName: DS.attr('string')
  mobileNumber: DS.attr('string')
  devicePlatfrom: DS.attr('string')
  verificationCode: DS.attr('string')
  verificationCodeDateTime: DS.attr('datetime')

  +computed firstName, lastName
  name: ->
    "#{@firstName} #{@lastName}"

`export default User`
