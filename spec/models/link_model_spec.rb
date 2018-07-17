require_relative '../../models/link'
require 'rspec'
require_relative '../spec_helper'

RSpec.describe Link, type: :model do
  DatabaseCleaner.strategy = :truncation

  before :each do
    @user = create(:user)
  end

  after :each do
    DatabaseCleaner.clean
  end

  context 'with valid attributes provided' do
    it 'should create a new link with the logged in user' do
      category = @user.categories.create(
        category_name: 'Superman',
        description: 'A world of heroes'
      )

      expect(category.links.new(
               link: 'https://en.wikipedia.org/wiki/Superman',
               link_name: 'Wikipedia Superman',
               snippet: 'Superman is a fictional superhero appearing in American comic books published by DC Comics.'
             )).to be_valid
    end
  end

  context 'with invalid attributes provided' do
    it 'should fail to create a new link with the logged in user' do
      category = @user.categories.create(
        category_name: 'Superman',
        description: 'A world of heroes'
      )

      expect(category.links.new(
               link: nil,
               link_name: nil,
               snippet: nil
             )).to be_invalid
    end
  end
end