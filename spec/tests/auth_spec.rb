describe "Signin" do
  before(:all) do
    @user = { name: "Bruce Banner", email: "bruce.banner@email.com", password: "12345678" }
    Database.new.db_query(query: "INSERT INTO users(name, email, password_hash, created_at, updated_at) " \
                                 "VALUES ('#{@user[:name]}', '#{@user[:email]}', '$2a$08$LxBMGhkQeNt5XQ3uvNmg4ed/1aVKaoDjn4QL9Om.7piz0M7Uku9lS', '#{Time.now}', '#{Time.now}');")
  end

  context "succesfully" do
    let(:result) { API.signin(body: { email: @user[:email], password: @user[:password] }) }
    it { expect(result.response.code).to eql "200" }
  end

  context "with invalid password" do
    let(:result) { API.signin(body: { email: @user[:email], password: "ABCDEFGH" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "Invalid password" }
  end

  context "with unregistered user" do
    let(:result) { API.signin(body: { email: "unregistered@email.com", password: "12345678" }) }
    it { expect(result.response.code).to eql "404" }
    it { expect(result.parsed_response["message"]).to eql "User not found" }
  end

  context "without email" do
    let(:result) { API.signin(body: { password: @user[:password] }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User email is required" }
  end

  context "without password" do
    let(:result) { API.signin(body: { email: @user[:email] }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User password is required" }
  end

  after(:all) do
    Database.new.db_query(query: "DELETE FROM users WHERE email = '#{@user[:email]}';")
  end
end
