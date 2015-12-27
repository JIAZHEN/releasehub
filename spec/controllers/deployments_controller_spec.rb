require "rails_helper"

RSpec.describe DeploymentsController, type: :controller do
  let(:environment) { create(:environment) }
  let(:repository) { create(:repository) }
  let(:branch) { create(:branch) }
  let(:current_username) { "releasehub" }

  before do
    allow(controller).to receive(:authenticated?).and_return(true)
    allow(controller).to receive(:current_username).and_return(current_username)
  end

  describe "#new" do
    before { get :new }

    it "setups variables" do
      expect(assigns(:repositories)).to eq([repository])
      expect(assigns(:environments)).to eq([environment])
    end
  end

  describe "#edit" do
    let(:deployment) { create(:deployment) }

    before { get :edit, :id => deployment.id }

    it "setups variables" do
      expect(assigns(:deployment)).to eq(deployment)
      expect(assigns(:repositories)).to eq([repository])
      expect(assigns(:environments)).to eq([deployment.environment, environment])
    end
  end

  describe "#create" do
    let(:branches) { create_list(:branch, 5) }
    let(:release) { create(:release) }
    let(:projects) do
      {
        "branches" => branches.map { |branch| branch.id },
        "shas" => branches.map { SecureRandom.hex },
        "deployment_instructions" => branches.map { "fake deploy" },
        "rollback_instructions" => branches.map { "fake rollback" }
      }
    end
    let(:params) do
      {
        "release_name" => release.name,
        "release_summary" => release.summary,
        "deployment" => {
          "notification_list" => "@release,@hub",
          "environment_id" => environment.id,
          "projects" => projects
        }
      }
    end

    context "when post data to create" do
      before do
        create(:status, :id => Status::WAIT_TO_DEPLOY)
        allow(controller).to receive(:slack_post).and_return("message posted")
        post :create, params
      end

      it "creates the release and projects" do
        expect(Release.count).to eq(1)
        expect(Project.count).to eq(branches.size)
      end

      it "displays the successful flash message" do
        message = "Thank you, the request has been submitted. " \
          "It should be deployed shortly."
        expect(flash[:success]).to eq(message)
      end

      it "redirects to new release path" do
        expect(response).to redirect_to new_deployment_path
      end
    end
  end

  describe "#update_status" do
    let(:deployment) { create(:deployment) }
    let(:status) { create(:status) }
    let(:data) {{ "deployment_id" => deployment.id, "status_id" => status.id }}

    before { allow(controller).to receive(:slack_post).and_return("message posted") }

    context "post with the id and new status" do
      before { xhr :post, :update_status, data }

      it "returns status colour and name of status" do
        expect(response.body).to eq(%Q{{"name":"#{status.name}","colour":null,"ops":"#{current_username}"}})
      end
    end
  end
end
