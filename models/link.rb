require 'sinatra/activerecord'

class Link < ActiveRecord::Base
  validates :link_name, :snippet,
            presence: true

  validates :link,
            presence: true,
            uniqueness: true

  belongs_to :category
end
