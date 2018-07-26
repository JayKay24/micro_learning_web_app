require 'pony'
require_relative '../services/bing_service'
require_relative '../models/user'
require_relative '../models/category'
require_relative '../models/link'
require 'rufus-scheduler'

def send_links
  users = User.all
  users.each do |user|
    categories = user.categories
    categories.each do |category|
      puts category.category_name
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
                  from: 'jaykaynjuguna@gmail.com',
                  subject: 'Micro Learning App',
                  body: category_link.link)
      end
    end
  end
end

scheduler = Rufus::Scheduler.new

scheduler.cron '5 0 * * *' do
  # send email every day, five minutes after midnight
  send_links
end

scheduler.join
