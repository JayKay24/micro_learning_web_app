require_relative '../../models/user'
require 'rspec'
require_relative '../spec_helper'
require 'database_cleaner'

RSpec.describe User, type: :model do
  context 'with valid attributes provided' do
    it 'should be valid with valid attributes' do
      should validate_presence_of :first_name
      should validate_presence_of :last_name
      should validate_presence_of :email
    end

    it 'should have many categories' do
      should have_many :categories
    end
  end

  context 'without valid attributes provided' do
    it 'should be invalid without valid attributes' do
      expect(User.new).to be_invalid
    end

    it 'should have a unique email' do
      should validate_uniqueness_of :email
    end

    it 'should raise a PasswordNotValidException if an invalid password is given' do
      expect {
        build(:user, password: 'qwertyuiop')
      }.to raise_exception(PasswordNotValidException)
      expect {
        build(:user, password: nil) 
      }.to raise_exception(PasswordNotValidException)
    end
  end
end