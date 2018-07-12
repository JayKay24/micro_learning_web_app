require 'net/https'
require 'uri'
require 'json'
require_relative '../../models/link'
require_relative '../../app/controllers/application_controller'
require_relative '../../models/category'
require_relative '../../services/bing_service'
require 'warden'

class LinkController < ApplicationController
  bing_search_api = BingService::BingWebSearchApi.new

  get '/category_links/:category_id' do
    redirect '/login' unless current_user
    @current_user = current_user

    term = @current_user.categories.find_by(id: params[:category_id].to_i)
    parsed_json = bing_search_api.links(term)

    @category_links = parsed_json['webPages']['value']

    haml :'category/category_links'
  end

  get '/category_link/:category_id' do
    redirect '/login' unless current_user
    @current_user = current_user

    term = Category.where(id: params[:category_id].to_i).first
    parsed_json = bing_search_api.links(term)

    result_set = parsed_json['webPages']['value']
    # result_set.shuffle!

    category = @current_user.categories.find_by(id: params[:category_id].to_i)

    link_name = category.links.find_by(link_name: result_set[0]['displayUrl'])

    until link_name.nil?
      result_set.shuffle!
      link_name = category.links.find_by(link_name: result_set[0]['displayUrl'])
    end

    category_link = category.links.create(
      link_name: result_set[0]['name'],
      link: result_set[0]['displayUrl'],
      snippet: result_set[0]['snippet']
    )
    category_link.save
    @category_links = [result_set[0]]

    haml :'category/category_links'
  end

  get '/history' do
    redirect '/login' unless current_user
    @current_user = current_user

    @category_links = @current_user.categories.map(&:links).flatten

    haml :'shared/link_history'
  end
end