require 'net/https'
require 'uri'
require 'json'
require_relative '../../models/link'
require_relative '../../app/controllers/application_controller'
require_relative '../../models/category'
require 'warden'

class LinkController < ApplicationController
  access_key = ENV['BING_API_ACCESS_KEY']
  uri = 'https://api.cognitive.microsoft.com'
  path = '/bing/v7.0/search'

  get '/category_links/:category_id' do
    redirect '/login' unless current_user
    @current_user = current_user

    term = Category.where(id: params[:category_id].to_i).first
    puts term.id
    puts term.category_name

    uri = URI(uri + path + '?q=' + URI.escape(term.category_name))

    puts 'Searching the Web for: ' + term.category_name

    request = Net::HTTP::Get.new(uri)
    request['Ocp-Apim-Subscription-Key'] = access_key

    response = Net::HTTP.start(uri.host,
                               uri.port,
                               use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    parsed_json = JSON.parse(response.body)
    @category_links = parsed_json['webPages']['value']

    haml :category_links
  end
end