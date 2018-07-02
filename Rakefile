require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'rubygems'
require 'coveralls/rake/task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
end

task default: :spec

Coveralls::RakeTask.new