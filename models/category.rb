require 'sinatra/activerecord'

class Category < ActiveRecord::Base
  validates :category_name, :description,
            presence: true

  validates :active,
            inclusion: { in: [true, false] }

  validates :time_interval,
            inclusion: { in: ['1', '5', '10'] }

  has_many :links, dependent: :destroy
  belongs_to :user
end