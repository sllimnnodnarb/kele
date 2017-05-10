require 'httparty'

class Kele

  include HTTParty

  def initialize(email, password)
    @bloc_base_api_url = "https://www.bloc.io/api/v1"
    @auth_token = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    raise "Wrong email and/or password" if @auth_token.nil?
  end

  def get_me
    @current_user = self.class.get('/users/me', headers: { "authorization" => @auth_token})
    @parsed_response = JSON.parse(response.body)
  end

end
