require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'

enable :sessions

get('/') do
  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  result = db.execute("SELECT * FROM entries")
  slim(:"home",locals:{home:result})
end

get('/add') do
  slim(:addentry)
end

post('/create') do
  entryname = params[:entryname]
  creator = params[:creator]
  category = params[:category]
  date = params[:releaseyear]
  img = params[:file]
  description = params[:description]
  tags = params[:tags]
  date2 = params[:date2]

  db = SQLite3::Database.new("db/database.db")
  db.results_as_hash = true
  if img && img[:filename]
      filename = img[:filename]
      file = img[:tempfile]
      path = "./public/img/#{filename}"
      File.open(path, 'wb') do |f|
          f.write(file.read)  
      end
  end
  result = db.execute("INSERT INTO entries (name,creator,category,description,tags,date,date2,img) VALUES(?,?,?,?,?,?,?,?)",[entryname,creator,category,description,tags,date,date2,filename])
  redirect("/")
end