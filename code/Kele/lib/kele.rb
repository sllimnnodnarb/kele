require 'httparty'

class Kele

  include HTTParty

  def initialize(email, password)
    @bloc_base_api_url = "https://www.bloc.io/api/v1"
    @auth_token = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    raise "Wrong email and/or password" is @authorization_token.code !=200
  end

end
