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

  describe 'sign in through omniauth twitter' do
    subject { get "/auth/twitter" }
    it 'should redirect to twitter authorize url' do
      expect(subject).to redirect_to("/omniauth/twitter?resource_class=User")
      expect(response.status).to eq(301)
    end
  end
end