require_relative '../../models/category'
require 'rspec'
require_relative '../spec_helper'

RSpec.describe Category, type: :model do
  DatabaseCleaner.strategy = :truncation

  let(:user) { create(:user) }

  after :each do
    DatabaseCleaner.clean
  end

  context 'with valid attributes provided' do
    it 'should create a new category with the logged in user' do
      expect(user.categories.new(
               category_name: 'Superman',
               description: 'A world of heroes'
             )).to be_valid
    end
  end

  context 'with invalid attributes provided' do
    it 'should fail to create a new category with the logged in user' do
      expect(user.categories.new(
               category_name: 'Superman',
               description: nil
             )).to be_invalid
    end
  end
end