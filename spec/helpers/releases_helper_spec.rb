require "rails_helper"

RSpec.describe ReleasesHelper, type: :helper do
  describe "#release_message" do
    let(:deployment) { create(:deployment) }
    let(:projects) { ["Mobile", "Desktop", "App"] }
    let(:project_names) { "Mobile, Desktop, App" }
    let(:deploy_url) { "https://test.host#{deployment_path(deployment)}" }
    let(:release_url) { "https://test.host#{release_path(deployment.release)}" }
    let(:text) do
      "<#{deploy_url}|##{deployment.id}> (<#{release_url}|#{deployment.release.name}>) " \
      "#{deployment.status.name} to #{deployment.environment.name} by @#{current_username}"
    end
    let(:expected_message) do
      [{
        fallback: "##{deployment.id} (#{deployment.release.name}) #{deployment.status.name} to #{deployment.environment.name} by @#{current_username}: #{deploy_url}",
        text: text,
        color: nil,
        fields: fields
      }].to_json
    end
    let(:current_username) { "releasehub" }

    before do
      allow(helper).to receive(:current_username).and_return(current_username)
      projects_array = []
      allow(deployment).to receive(:projects).and_return(projects_array)
      allow(projects_array).to receive(:map).and_return(projects)
    end

    context "when dev is the same as current username" do
      let(:current_username) { deployment.dev }
      let(:fields) do
        [
          { title: "Projects", value: project_names, short: true }
        ]
      end

      it "does not include dev name" do
        expect(helper.release_message(deployment)).to eq(expected_message)
      end
    end

    context "when not to notify people" do
      let(:text) do
        "<#{deploy_url}|##{deployment.id}> (<#{release_url}|#{deployment.release.name}>) " \
        "#{deployment.status.name} to #{deployment.environment.name} by @#{current_username} for @#{deployment.dev}"
      end
      let(:fields) do
        [
          { title: "Projects", value: project_names, short: true }
        ]
      end

      it "does not include notification list" do
        expect(helper.release_message(deployment)).to eq(expected_message)
      end
    end

    context "when notify people" do
      let(:text) do
        "<#{deploy_url}|##{deployment.id}> (<#{release_url}|#{deployment.release.name}>) " \
        "#{deployment.status.name} to #{deployment.environment.name} by @#{current_username} for @#{deployment.dev}"
      end
      let(:fields) do
        [
          { title: "Projects", value: project_names, short: true },
          { title: "Notify", value: deployment.notification_list, short: true }
        ]
      end

      before { allow(deployment).to receive(:notify_people?).and_return(true) }

      it "includes Notify" do
        expect(helper.release_message(deployment)).to eq(expected_message)
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
