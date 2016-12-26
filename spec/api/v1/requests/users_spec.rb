require 'rails_helper'

describe 'v1 users', type: :request do
  describe '#index' do
    it 'can be viewed only by authorized user' do
    end

    it 'gives errors to unauthorized user' do
      get '/api/v1/users'
      expect(response.status).to eq(401)
    end
  end

  describe '#show' do
  end
end