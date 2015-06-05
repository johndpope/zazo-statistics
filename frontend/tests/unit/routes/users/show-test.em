`import { test, moduleFor } from 'ember-qunit'`

# (ember)

moduleFor 'route:users.show', 'UserShowRoute', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', ->
  route = @subject()
  ok route
