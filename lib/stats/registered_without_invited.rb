data  = EventsApi.new.metric_data :registered_not_invited
mkeys = data.map { |row| row['initiator_id'] }
scope = User.where(mkey: mkeys)
users = scope.each_with_object({}) { |user, memo| memo[user.mkey] = user }

results = data.map do |row|
  user = users[row['initiator_id']]
  { mkey: row['initiator_id'],
    name: user.try(:name),
    status: user.try(:status),
    platform: user.try(:device_platform),
    connections: (user.connections.count rescue 0),
    registered_at: row['registered_at'] }
end

File.open('doc/registered_not_invited.csv', 'w') do |file|
  file.write "mkey,name,status,platform,connections,registered_at\n"
  results.each do |res|
    file.write "#{res[:mkey]},#{res[:name]},#{res[:status]},#{res[:platform]},#{res[:connections]},#{res[:registered_at]}\n"
  end
end
