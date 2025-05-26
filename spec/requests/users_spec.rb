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
                                    { id: user1.id, name: "John Doe",      age: 45, gender: "male",   latitude: 19.98, longitude: 29.88, infected: false },
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
      let(:params) { { name: nil, gender: nil, latitude: nil, longitude: nil, birthdate: "01" } }

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

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:params) do
        {
          latitude: -14.2400732,
          longitude: -53.1805017
        }
      end

      it "updates the users location" do
        user = User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")

        patch "/api/v1/users/#{user.id}", params: { user: params }, as: :json
        user.reload
        expect(user.latitude).to eq -14.2400732
        expect(user.longitude).to eq -53.1805017
      end
    end

    context "with invalid parameters" do
      let(:params) do
        {
          latitude: nil,
          longitude: "joia"
        }
      end

      it "updates the users location" do
        user = User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")

        patch "/api/v1/users/#{user.id}", params: { user: params }, as: :json
        user.reload
        expect(user.latitude).to eq 100
        expect(user.longitude).to eq 200
        expect(response.body).to eq({ errors: "Latitude can't be blank" }.to_json)
        expect(response.status).to eq 422
      end
    end
  end

  describe "PATCH /report_infected" do
    context "with valid parameters" do
      let(:suspect) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      let(:reporter) {
        User.create!(name: "Clark Kent", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      let(:attributes) do
        {
          reporter_user_id: reporter.id
        }
      end

      it "creates a report record" do
        expect do
          patch "/api/v1/users/#{suspect.id}/report_infected", params: { user: { id: suspect.id, reporter_user_id: reporter.id } }, as: :json
        end.to change { InfectedUserReport.count }.by(1)

        expect(response.status).to eq 200
        suspect.reload
        infected_report = InfectedUserReport.last

        expect(infected_report.suspect).to eq suspect
        expect(infected_report.reporter).to eq reporter
        expect(response.body).to eq infected_report.to_json
      end
    end

    context "with invalid parameters" do
      let(:suspect) {
        User.create!(name: "John Doe", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      let(:reporter) {
        User.create!(name: "Clark Kent", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
      }

      it "returns not found" do
        expect do
          patch "/api/v1/users/#{suspect.id}/report_infected", params: { user: { id: suspect.id, reporter_user_id: nil } }, as: :json
        end.to change { InfectedUserReport.count }.by(0)

        expect(response.status).to eq 404
      end
    end

    describe 'get /user/:id' do
      context 'for an existing user' do
        let(:user) {
          User.create!(name: "Johnny Bravo", latitude: 100, longitude: 200, gender: 'male', birthdate: "1980-01-01")
        }

        it 'returns 404 status' do
          get "/api/v1/users/#{user.id}", headers: headers
          expect(response.status).to eq 200
        end
      end

      context 'for an unexisting user' do
        it 'returns 404 status' do
          get "/api/v1/users/0", headers: headers
          expect(response.status).to eq 404
        end
      end
    end
  end
end
