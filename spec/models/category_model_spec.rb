require_relative '../../models/category'
require 'rspec'
require_relative '../spec_helper'

RSpec.describe Category, type: :model do
  context 'with valid attributes provided' do
    it 'should create a new category with the logged in user' do
      should validate_presence_of :category_name
      should validate_presence_of :description
    end
  end

  it 'should belong to one user' do
    should belong_to :user
  end

  it 'should have many links' do
    should have_many :links
  end
end