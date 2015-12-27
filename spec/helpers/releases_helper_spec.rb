require "rails_helper"

RSpec.describe ReleasesHelper, type: :helper do
  describe "#release_message" do
    let(:deployment) { create(:deployment) }
    let(:project_names) { "Mobile,Desktop,App" }
    let(:expected_message) do
      [{
        fallback: "<https://test.host/deployments/#{deployment.id}|RR(deployment-#{deployment.id})> is \"#{deployment.status.name}\" by @releasehub cc #{deployment.notification_list}",
        text: "<https://test.host/deployments/#{deployment.id}|RR(deployment-#{deployment.id})> is \"#{deployment.status.name}\" by @releasehub",
        fields: fields,
        color: nil
      }].to_json
    end

    before do
      allow(helper).to receive(:current_username).and_return("releasehub")
    end

    context "when not to notify people" do
      let(:fields) do
        [
          { title: "Projects", value: project_names, short: true },
          { title: "Environment", value: deployment.environment.name, short: true },
          { title: "Dev", value: deployment.dev, short: true }
        ]
      end

      it "does not include notification list" do
        expect(helper.release_message(project_names, deployment)).to eq(expected_message)
      end
    end

    context "when notify people" do
      let(:fields) do
        [
          { title: "Projects", value: project_names, short: true },
          { title: "Environment", value: deployment.environment.name, short: true },
          { title: "Dev", value: deployment.dev, short: true },
          { title: "Notification list", value: deployment.notification_list, short: true }
        ]
      end

      before { allow(deployment).to receive(:notify_people?).and_return(true) }

      it "includes notification list" do
        expect(helper.release_message(project_names, deployment)).to eq(expected_message)
      end
    end
  end

  describe "#status_colour" do
    let(:status) { Status.new(:id => status_id) }
    let(:object) { double("object", :status => status) }

    context "when default is not provided" do
      let(:status_id) { Status::WAIT_TO_DEPLOY }

      it "returns primary as colour" do
        expect(helper.status_colour(object)).to eq("primary")
      end
    end

    context "when default is provided" do
      let(:status_id) { nil }

      it "returns primary as colour" do
        expect(helper.status_colour(object, "another")).to eq("another")
      end
    end
  end
end
