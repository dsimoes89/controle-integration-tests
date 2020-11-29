require "pg"

class Database
  def initialize
    conn = { host: "localhost", dbname: "database_dev", user: "postgres", password: "docker" }
    @connection = PG.connect(conn)
  end

  def db_query(query:)
    @connection.exec(query)
  end
end
