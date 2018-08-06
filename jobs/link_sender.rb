require 'pony'
require_relative '../services/bing_service'
require_relative '../models/user'
require_relative '../models/category'
require_relative '../models/link'

module LinkSender
  def send_mail(recipient, body)
    Pony.options = { via_options: {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: ENV['LINK_SENDER_EMAIL'],
      password: ENV['LINK_SENDER_EMAIL_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }, via: :smtp }
    Pony.mail(to: recipient,
              from: ENV['LINK_SENDER_EMAIL'],
              subject: 'Micro learning App',
              body: body)
  end

  def prepend_https_to_canonical_url(result_set)
    if result_set[0]['displayUrl'].start_with?('http', 'https')
      result_set[0]['displayUrl'].strip
    else
      'https://' + result_set[0]['displayUrl'].strip
    end
  end

  def send_links
    users = User.all
    users.each do |user|
      categories = user.categories.includes(:links)
      categories.each do |category|
        if category.active
          bing_web_search = BingService::BingWebSearchApi.new
          result_set = bing_web_search.links(category)['webPages']['value']
          canonical_url = prepend_https_to_canonical_url(result_set)
          link_name = category.links.find_by(link: canonical_url)
          until link_name.nil?
            result_set.shuffle!
            canonical_url = prepend_https_to_canonical_url(result_set)
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
          email_body = "Here's today's link:\n" \
                       "#{category_link.link}\n" \
                       "Name:\n#{category_link.link_name}\n" \
                       "Description:\n#{category_link.snippet}"
          send_mail(user.email, email_body)
        end
      end
    end
  end
end

