require_relative '../../models/user'
require 'rspec'
require_relative '../spec_helper'
require 'database_cleaner'

RSpec.describe User, type: :model do
  DatabaseCleaner.strategy = :truncation

  before :all do
    DatabaseCleaner.clean
  end

  after :each do
    DatabaseCleaner.clean
  end

  context 'with valid attributes provided' do
    it 'should be valid with valid attributes' do
      expect(User.new(
               first_name: 'Clark',
               last_name: 'Kent',
               email: 'clark@example.com',
               password: 'Qwertyuiop123#'
             )).to be_valid
    end
  end

  context 'without valid attributes provided' do
    it 'should be invalid without valid attributes' do
      expect(User.new).to be_invalid
    end

    it 'should have a unique email' do
      create(:user)
      user2 = build(:user, first_name: 'Lex',
                           last_name: 'Luthor',
                           email: 'clark@example.com',
                           password: 'Qwertyuiop123#')

      expect(user2).to be_invalid
    end


    it 'should raise a PasswordNotValidException if an invalid password is given' do
      expect { build(:user, password: 'qwertyuiop') }.to raise_exception(PasswordNotValidException)
    end
  end
end