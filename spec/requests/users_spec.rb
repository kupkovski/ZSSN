require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /index" do
    let!(:user1) do
      ::User.create!(
        name: 'John Doe',
        gender: 'male',
        latitude: 19.98,
        longitude: 29.88,
        birthdate: '1980-01-01'
      )
    end

    let!(:user2) do
      ::User.create!(
        name: 'Jaqueline Doe',
        gender: 'female',
        latitude: 29.98,
        longitude: 49.88,
        birthdate: '1980-07-01'
      )
    end

    it 'succeeds with a json response' do
      get '/api/v1/users', headers: headers
      expect(response.status).to eq 200
      expect(response.body).to eq [
                                    { id: user1.id, name: "John Doe",      age: 45, gender: "male",  latitude: 19.98, longitude: 29.88, infected: false },
                                    { id: user2.id, name: "Jaqueline Doe", age: 44, gender: "female", latitude: 29.98, longitude: 49.88, infected: false }
      ].to_json
    end
  end

  describe 'POST /users' do
    context 'with valid params' do
      let(:params) { { name: "New Testing User", gender: "male", latitude: 10.0, longitude: 11.0, birthdate: Date.current } }
      it 'creates a new user' do
        expect do
          post '/api/v1/users', headers: headers, params: { user: params }
        end.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post api_v1_users_url, params: { user: params }, headers: headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      let(:params) {
        {
          name: nil,
          gender: nil,
          latitude: nil,
          longitude: nil,
          birthdate: "01"
        }
      }

      it "does not create a new User" do
        expect {
          post '/api/v1/users', headers: headers, params: { user: params }
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors for the new user" do
        post '/api/v1/users', headers: headers, params: { user: params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expected_errors = { errors: "Name can't be blank, Gender can't be blank, Latitude can't be blank, and Longitude can't be blank" }.to_json
        expect(response.body).to eq expected_errors
      end
    end
  end
end
