require "sqlite3"

# here's the script you can run to make a new db, or to reset an existing one
#
# WARNING: running this will destroy what's in your database!!!
#

db = SQLite3::Database.new("app.db")

result = db.execute <<-SQL
  DROP TABLE IF EXISTS users
SQL

if result == []
  puts "dropped users"
end

result = db.execute <<-SQL
  CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(30),
    favorites NOT NULL
  );
SQL

if result == []
  puts "created users"
end
