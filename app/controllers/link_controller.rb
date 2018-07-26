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
    term = @current_user.categories.find(params[:category_id])
    parsed_json = bing_search_api.links(term)

    @category_links = parsed_json['webPages']['value']

    haml :'category/category_links'
  end

  get '/category_link/:category_id' do
    term = Category.where(id: params[:category_id].to_i).first
    parsed_json = bing_search_api.links(term)

    result_set = parsed_json['webPages']['value']

    category = @current_user.categories.find(params[:category_id])

    canonical_url = result_set[0]['displayUrl'].strip
    unless result_set[0]['displayUrl'].start_with?('http', 'https')
      canonical_url = 'https://' + result_set[0]['displayUrl'].strip
    end

    link_name = category.links.find_by(link: canonical_url)

    until link_name.nil?
      result_set.shuffle!
      canonical_url = result_set[0]['displayUrl'].strip
      unless result_set[0]['displayUrl'].start_with?('http', 'https')
        canonical_url = 'https://' + result_set[0]['displayUrl'].strip
      end
      link_name = category.links.find_by(link: canonical_url)
    end

    category_link = category.links.create(
      link_name: result_set[0]['name'],
      link: canonical_url,
      snippet: result_set[0]['snippet']
    )
    category_link.save
    @category_links = [{
      'name' => category_link.link_name,
      'displayUrl' => category_link.link,
      'snippet' => category_link.snippet
    }]

    haml :'category/category_links'
  end

  get '/history' do
    @category_links = @current_user.categories.map(&:links).flatten.reverse

    haml :'shared/link_history'
  end

  get '/link/today' do
    category = @current_user.categories.where(active: true).first
    @latest_link = category.links.where(scheduled: true).last if category

    haml :'link/link'
  end
  get '/link/view' do
    category = @current_user.categories.where(active: true).first
    if category
      latest_link = category.links.where(scheduled: true).last
      if latest_link
        flash[:success] = "Here's today's link."
      else
        flash[:error] = "You are yet to receive today's link. Please come back later."
      end
    else
      flash[:error] = 'You currently have no active category. Please set one in the settings tab.'
    end

    redirect '/link/today'
  end
end