require_relative '../models/user'

users = [
  { first_name: 'James', last_name: 'Njuguna',
    email: 'jameskinyua590@gmail.com', password: 'Qwertyuiop123#' },
  { first_name: 'James', last_name: 'Kinyua',
    email: 'james.njuguna@andela.com', password: 'Qwertyuiop123#' }
]

users.each { |user| User.create(user) }
