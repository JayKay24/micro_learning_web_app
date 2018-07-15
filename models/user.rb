require 'sinatra/activerecord'
require 'rubygems'
require 'bcrypt'


class User < ActiveRecord::Base
  validates :first_name, :last_name,
            presence: true,
            length: { in: 2..20 }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  has_many :categories

  # Cipher the password when it is created
  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    user if user && BCrypt::Password.new(user.password_digest) == password
  end
end