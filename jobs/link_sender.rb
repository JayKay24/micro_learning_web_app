require 'pony'
require_relative '../services/bing_service'
require_relative '../models/user'
require_relative '../models/category'
require_relative '../models/link'

module LinkSender
  def send_links
    Pony.options = { via_options: {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: ENV['LINK_SENDER_EMAIL'],
      password: ENV['LINK_SENDER_EMAIL_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }, via: :smtp }

    users = User.all
    users.each do |user|
      categories = user.categories
      categories.each do |category|
        if category.active
          bing_web_search = BingService::BingWebSearchApi.new
          parsed_json = bing_web_search.links(
            category
          )
          result_set = parsed_json['webPages']['value']
          canonical_url = result_set[0]['displayUrl'].strip
          unless result_set[0]['displayUrl'].start_with?('http', 'https')
            canonical_url = 'https://' + result_set[0]['displayUrl'].strip
          end
          link_name = category.links.find_by(
            link: canonical_url)
          until link_name.nil?
            result_set.shuffle!
            canonical_url = result_set[0]['displayUrl'].strip
            unless result_set[0]['displayUrl'].start_with?('http', 'https')
              canonical_url = 'https://' + result_set[0]['displayUrl'].strip
            end
            link_name = category.links.find_by(
              link: canonical_url
            )
          end
          category_link = category.links.create(
            link_name: result_set[0]['name'],
            link: canonical_url,
            snippet: result_set[0]['snippet'],
            scheduled: true
          )
          Pony.mail(to: user.email,
                    from: ENV['LINK_SENDER_EMAIL'],
                    subject: 'Micro Learning App',
                    body: "Here's today's link:\n
                    '#{category_link.link}'\n
                    Description:\n
                    '#{category_link.snippet}'
                    ")
        end
      end
    end
  end
end

