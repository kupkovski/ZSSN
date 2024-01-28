require 'rails_helper'

RSpec.describe "/api/v1/report_infected", type: :request do
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
          patch report_infected_api_v1_user_url(suspect), params: { user: { id: suspect.id, reporter_user_id: reporter.id } }, as: :json
        end.to change { InfectedUserReport.count }.by(1)
        expect(response.status).to eq 200
        suspect.reload
        infected_report = InfectedUserReport.last

        expect(infected_report.suspect).to eq suspect
        expect(infected_report.reporter).to eq reporter
        expect(response.body).to eq infected_report.to_json
      end
    end



  end
end
