require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'rubygems'
require 'coveralls/rake/task'
require './jobs/link_sender.rb'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

task default: :spec

namespace :mailer do
  desc 'Send out links to registered users'
  task :send_links do
    include LinkSender
    send_links
  end
end

Coveralls::RakeTask.new
