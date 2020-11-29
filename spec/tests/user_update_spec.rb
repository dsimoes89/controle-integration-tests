describe("User update") do
  before(:all) do
    @user = { name: "Tony Stark", email: "tony.stark@email.com", password: "12345678" }
    Database.new.db_query(query: "INSERT INTO users(name, email, password_hash, created_at, updated_at) " \
                                 "VALUES ('#{@user[:name]}', '#{@user[:email]}', '$2a$08$LxBMGhkQeNt5XQ3uvNmg4ed/1aVKaoDjn4QL9Om.7piz0M7Uku9lS', '#{Time.now}', '#{Time.now}');")
    @token = API.authentication(email: @user[:email], password: @user[:password])
    @user_edited = { name: "Tony Edited", email: "tony.edited@email.com" }

    @other_user = { name: "Dare Devil", email: "dare.devil@email.com", password: "12345678" }
    Database.new.db_query(query: "INSERT INTO users(name, email, password_hash, created_at, updated_at) " \
                                 "VALUES ('#{@other_user[:name]}', '#{@other_user[:email]}', '$2a$08$LxBMGhkQeNt5XQ3uvNmg4ed/1aVKaoDjn4QL9Om.7piz0M7Uku9lS', '#{Time.now}', '#{Time.now}');")
  end

  context "successfully" do
    let(:result) { API.user_profile(auth: @token, body: @user_edited) }
    let(:database) { Database.new.db_query(query: "SELECT * FROM users WHERE id = #{result.parsed_response['id']};").first }
    it { expect(result.response.code).to eql "200" }
    it { expect(result.parsed_response["name"]).to eql database["name"] }
    it { expect(result.parsed_response["email"]).to eql database["email"] }
  end

  context "with empty name" do
    let(:result) { API.user_profile(auth: @token, body: { name: "" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User name cannot be empty" }
  end

  context "with empty email" do
    let(:result) { API.user_profile(auth: @token, body: { email: "" }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User email cannot be empty" }
  end

  context "with email already registered" do
    let(:result) { API.user_profile(auth: @token, body: { email: @other_user[:email] }) }
    it { expect(result.response.code).to eql "400" }
    it { expect(result.parsed_response["message"]).to eql "User already exists" }
  end

  context "password" do
    let(:result) { API.user_profile(auth: @token, body: { password: "12345678" }) }
    it { expect(result.response.code).to eql "405" }
    it { expect(result.parsed_response["message"]).to eql "Method not allowed to change password" }
  end

  after(:all) do
    Database.new.db_query(query: "DELETE FROM users WHERE email = '#{@user_edited[:email]}';")
    Database.new.db_query(query: "DELETE FROM users WHERE email = '#{@other_user[:email]}';")
  end
end
