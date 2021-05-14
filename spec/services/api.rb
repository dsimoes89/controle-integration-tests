class API
  include HTTParty
  base_uri "http://localhost:3333"

  def self.authentication(email:, password:)
    headers "Content-Type" => "application/json"
    result = post("/signin", body: { email: email, password: password }.to_json)
    result.parsed_response["token"]
  end

  def self.signin(body:)
    headers "Content-Type" => "application/json"
    post("/signin", body: body.to_json)
  end

  def self.signup(body:)
    headers "Content-Type" => "application/json"
    post("/signup", body: body.to_json)
  end

  def self.user_profile(auth:, body:)
    headers "Content-Type" => "application/json"
    headers "Authorization" => "Bearer #{auth}"
    put("/user/profile", body: body.to_json)
  end
end
