class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :mobile_number, :device_platform,
              :mkey, :auth, :verification_code, :verification_date_time, :status
end
