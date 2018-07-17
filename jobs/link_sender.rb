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
        puts 'this is the result set'
        puts result_set
        link_name = category.links.find_by(
          link: result_set[0]['displayUrl'])
        until link_name.nil?
          result_set.shuffle!
          link_name = category.links.find_by(
            link: result_set[0]['displayUrl']
          )
        end
        category_link = category.links.create(
          link_name: result_set[0]['name'],
          link: result_set[0]['displayUrl'],
          snippet: result_set[0]['snippet']
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
