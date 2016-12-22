require 'rails_helper'

describe 'users', type: :request do
  describe 'registered with email' do
    let(:email){ "user@example.com" }
    let(:password){ "password" } 

    it 'should success with correct information' do
      post "/auth", 
        params: "\{ \"email\": \"#{email}\", \"password\": \"#{password}\" \}",
        headers: { "Content-Type": "application/json"}
      expect(response.status).to eq(200)
    end

    it 'should failed with incorrect information' do
      post "/auth", 
        params: "\{ \"email\": \"#{email}\" \}",
        headers: { "Content-Type": "application/json"}
      expect(response.status).to eq(422)
    end
  end

  describe 'create through omniauth' do
  end
end