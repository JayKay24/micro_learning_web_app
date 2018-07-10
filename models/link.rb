require 'sinatra/activerecord'

class Link < ActiveRecord::Base
  validates :link_name,
            presence: true

  belongs_to :category
end