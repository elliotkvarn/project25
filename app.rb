require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'
require 'bcrypt'

get('/') do
  db = SQLite3::Database.new("db/database.db")
  @entries = db.execute("SELECT name FROM entries")
  slim(:home)
end

get('/add') do
  p "hej"
  slim(:addentry)
end

post('/create') do
  if params[:file] && params[:file][:filename]
    filename = params[:file][:filename]
    file = params[:file][:tempfile]
  db.execute("INSERT INTO entries(img) VALUES ?", [:filename])
  #skapa sträng
  path = File.join("/public/uploaded_pictures/",params[:file][:filename])

  #spara bilden
  File.write(path,File.read(params[:file][:tempfile]))

  redirect("/")

end