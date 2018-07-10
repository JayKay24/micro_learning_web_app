require 'sinatra/activerecord'

class Category < ActiveRecord::Base
  validates :category_name, :description,
            presence: true

  has_many :links
  belongs_to :user
end