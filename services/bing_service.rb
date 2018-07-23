require 'net/https'
require 'uri'
require 'json'

module BingService
  class BingWebSearchApi
    def links(search_term)
      access_key = 'ff874699981347b49bb78f71f55b63d5'
      uri = 'https://api.cognitive.microsoft.com'
      path = '/bing/v7.0/search'

      uri = URI(uri + path + '?q=' + URI.escape(search_term.category_name))

      puts 'Searching the Web for: ' + search_term.category_name

      request = Net::HTTP::Get.new(uri)
      request['Ocp-Apim-Subscription-Key'] = access_key

      response = Net::HTTP.start(uri.host,
                                 uri.port,
                                 use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      JSON.parse(response.body)
    end
  end
end