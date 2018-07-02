configure :production, :development do
  db = URI.parse(ENV['MICRO_LEARNING_DATABASE_URL'] ||
                     'postgres://localhost/micro_learning')

  ActiveRecord::Base.establish_connection(
    adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    host: db.host,
    username: db.user,
    password: db.password,
    database: db.path[1..-1],
    encoding: 'utf8'
  )
end

configure :test do
  db = URI.parse(ENV['MICRO_LEARNING_TEST_DATABASE_URL'] ||
      'postgres://localhost/micro_learning_test')

  ActiveRecord::Base.establish_connection(
    adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    host: db.host,
    username: db.user,
    password: db.password,
    database: db.path[1..-1],
    encoding: 'utf8'
  )
end