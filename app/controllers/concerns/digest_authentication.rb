module DigestAuthentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = 'zazo.com'

  included do
    attr_accessor :current_client
    before_action :authenticate
  end

  protected

  def authenticate
    authenticate_with_digest
  end

  def authenticate_with_digest
    authenticate_or_request_with_http_digest(REALM) do |service_name|
      self.current_client = service_name
      current_client && ClientCredentials.password_for(current_client)
    end
  end

  def request_http_digest_authentication(realm = REALM)
    super(realm, { status: :unauthorized }.to_json)
  end
end
