describe("User register") do
  before(:all) do
    @user = { name: "Peter Parker", email: "peter.parker@email.com", password: "12345678" }
  end

  context "succesfully" do
    let(:result) { API.signup(body: @user) }
    it { expect(result.response.code).to eql "201" }
  end

  context "with undefined name" do
    let(:result) { API.signup(body: { email: "peter.parker@email.com", password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User name is required" }
  end

  context "with null name" do
    let(:result) { API.signup(body: { name: nil, email: "peter.parker@email.com", password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User name is required" }
  end

  context "with empty name" do
    let(:result) { API.signup(body: { name: "", email: "peter.parker@email.com", password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User name is required" }
  end

  context "with duplicated email" do
    let(:result) { API.signup(body: @user) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User already exists" }
  end

  context "with undefined email" do
    let(:result) { API.signup(body: { name: "Peter Parker", password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User email is required" }
  end

  context "with null email" do
    let(:result) { API.signup(body: { name: "Peter Parker", email: nil, password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User email is required" }
  end

  context "with empty email" do
    let(:result) { API.signup(body: { name: "Peter Parker", email: "", password: "12345678" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User email is required" }
  end

  context "with undefined password" do
    let(:result) { API.signup(body: { name: "Peter Parker", email: "peter.parker@email.com" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User password is required" }
  end

  context "with null password" do
    let(:result) { API.signup(body: { name: "Peter Parker", email: "peter.parker@email.com", password: nil }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User password is required" }
  end

  context "with empty password" do
    let(:result) { API.signup(body: { name: "Peter Parker", email: "peter.parker@email.com", password: "" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User password is required" }
  end

  after(:all) do
    Database.new.db_query(query: "DELETE FROM users WHERE email = '#{@user[:email]}';")
  end
end
