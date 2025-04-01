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

post('/register') do
  username = params[:username]
  password = params[:password]
  password_confirm = params[:password_confirm]

  db = SQLite3::Database.new('db/database.db')
  db.results_as_hash = true
  result = db.execute('SELECT id FROM users WHERE username=?',username)

  if result.empty?
    if (password == password_confirm)
      password_digest = BCrypt::Password.create(password)
      db.execute("INSERT INTO users (username,pw) VALUES (?,?)", [username, password_digest])
      redirect('/')
    else
      set_error("Password don't match")
      redirect('/register')
    end
  else
    set_error('Username already exists')
    redirect('/register')
end

post('/login') do
  username = params["username"]
  password = params["password"]
  
  db = SQLite3::Database.new('db/db.db')
  db.results_as_hash = true
  result = db.execute("SELECT * FROM users WHERE username = ?",username).first
  pwdigest = result["pwdigest"]
  id = result["id"]


  if BCrypt::Password.new(pwdigest) == password
    session[:id] = id
    redirect('/todos')
  else
    "fel lösen!!"
  end
end