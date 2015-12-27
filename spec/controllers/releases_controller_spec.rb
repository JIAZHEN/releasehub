require "rails_helper"

RSpec.describe ReleasesController, type: :controller do
  let(:environment) { create(:environment) }
  let(:repository) { create(:repository) }
  let(:branch) { create(:branch) }

  before do
    allow(controller).to receive(:authenticated?).and_return(true)
  end

  describe "#get_branches" do
    context "post without repository name" do
      before { xhr :post, :get_branches, {} }

      it "returns error message" do
        expect(response.body).to eq(%Q{{"error":"Invalid repository name"}})
      end
    end

    context "post to get active branches" do
      let(:repository_with_branches) { create(:repository_with_branches) }

      before { xhr :post, :get_branches, { "repository" => repository_with_branches.name } }

      it "returns branches" do
        expect(response.body).to eq(repository_with_branches.branches.to_json)
      end
    end

    context "post to sync github branches" do
      let(:repository_with_branches) { create(:repository_with_branches) }
      let(:active_branches) { repository_with_branches.branches.take(2) }

      before do
        stub_request(:get, "https://api.github.com/repos/#{repository_with_branches.name}/branches?per_page=100").
          to_return(:status => 200, :body => active_branches)
        xhr :post, :get_branches, { "repository" => repository_with_branches.name, "type" => "sync" }
      end

      it "returns branches" do
        expect(response.body).to eq(active_branches.to_json)
      end
    end
  end

  describe "#get_sha" do
   context "when branch is empty" do
      before do
        stub_request(:get, "https://api.github.com/repos/#{repository.name}/branches/").
         to_return(:status => 404, :body => "")
        xhr :post, :get_sha, { "repository" => repository.name, "branch" => "" }
      end

      it "returns error message" do
        expect(response.body).to eq(%Q{{"error":"Invalid repository/branch name"}})
      end
    end
  end

  describe "#update_status" do
   context "when release is not found" do
      before do
        xhr :post, :update_status, { "release_id" => -1, "branch" => "" }
      end

      it "returns error message" do
        expect(response.body).to eq(%Q{{"error":"Invalid release id"}})
      end
    end
  end
end
