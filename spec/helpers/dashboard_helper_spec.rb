require "rails_helper"

RSpec.describe DashboardHelper, type: :helper do
  describe "#env_to_colour" do
    it "returns qa for qa 1~5" do
      %w(qa1 qa2 qa3 qa4 qa5).each do |env|
        expect(helper.env_to_colour(env)).to eq("qa")
      end
    end

    it "returns uat for uat 1~5" do
      %w(uat1 uat2).each do |env|
        expect(helper.env_to_colour(env)).to eq("uat")
      end
    end

    it "returns live for production" do
      %w(production).each do |env|
        expect(helper.env_to_colour(env)).to eq("live")
      end
    end
  end

  describe "#env_name" do
    it "returns original name for qa and uat" do
      %w(qa1 qa2 qa3 qa4 qa5 uat1 uat2).each do |name|
        env = Environment.new(:name => name)
        expect(helper.env_name(env)).to eq(name)
      end
    end

    it "returns live for production" do
      %w(production).each do |name|
        env = Environment.new(:name => name)
        expect(helper.env_name(env)).to eq("live")
      end
    end
  end

  describe "#sha_url" do
    let(:repo) { "hub" }
    let(:sha) { "123456" }

    before { stub_const("ReleasesHelper::ORGANISATION", "release") }

    it "returns the right sha based on repo and sha" do
      expect(helper.sha_url(repo, sha)).to eq("https://github.com/release/hub/commit/123456")
    end
  end

  describe "#branch_url" do
    let(:repo) { "hub" }
    let(:branch) { "pb-2137-toggle" }

    before { stub_const("ReleasesHelper::ORGANISATION", "release") }

    it "returns the right branch based on repo and branch" do
      expect(helper.branch_url(repo, branch)).to eq("https://github.com/release/hub/pull/pb-2137-toggle")
    end
  end
end
