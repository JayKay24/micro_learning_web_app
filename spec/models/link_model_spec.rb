require_relative '../../models/link'
require 'rspec'
require_relative '../spec_helper'

RSpec.describe Link, type: :model do
  context 'with valid attributes provided' do
    it 'should create a new link with the logged in user' do
      should validate_presence_of :link_name
      should validate_presence_of :link
      should validate_presence_of :snippet
    end
  end

  it 'should have a unique link' do
    should validate_uniqueness_of :link
  end

  it 'should belong to a category' do
    should belong_to :category
  end
end
