require 'sinatra/activerecord'

class Link < ActiveRecord::Base
  validates :link_name, :snippet, :link,
            presence: true

  belongs_to :category
end