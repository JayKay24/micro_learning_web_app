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
    check_if_logged_in

    term = @current_user.categories.find(params[:category_id])
    parsed_json = bing_search_api.links(term)

    @category_links = parsed_json['webPages']['value']

    haml :'category/category_links'
  end

  get '/category_link/:category_id' do
    check_if_logged_in

    term = Category.where(id: params[:category_id].to_i).first
    parsed_json = bing_search_api.links(term)

    result_set = parsed_json['webPages']['value']

    category = @current_user.categories.find(params[:category_id])

    link_name = category.links.find_by(link: result_set[0]['displayUrl'])

    until link_name.nil?
      result_set.shuffle!
      link_name = category.links.find_by(link: result_set[0]['displayUrl'])
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
    check_if_logged_in

    @category_links = @current_user.categories.map(&:links).flatten

    haml :'shared/link_history'
  end
end