module ResourceAuthorization
  def authorize_resource(resource)
    token = AuthenticateResource.call(email: resource.email, password: resource.password)
    header 'Authorization', "Bearer #{token}"
  end
end
