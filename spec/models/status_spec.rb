require "rails_helper"

RSpec.describe Status, type: :model do
  let(:status) { described_class.new }
  let(:release_status) { Status.where(:name.in => Status::RELEASE_STATUS) }
  let(:deployment_status) { Status.where(:name.in => Status::DEPLOYMENT_STATUS) }

  subject { status }

  it { is_expected.to respond_to(:name) }

  before do
    [
      "waiting to deploy", "deploying", "deployed", "rollback",
      "open", "finish", "cancelled"
    ].each do |name|
      Status.find_or_create_by(name: name)
    end
  end

  describe "#name" do
    describe "when name is not present" do
      it { is_expected.not_to be_valid }
    end

    describe "when name is empty" do
      before { status.name = " " }

      it { is_expected.not_to be_valid }
    end

    describe "when name is over 30 characters" do
      before { status.name = "a" * 31 }

      it { is_expected.not_to be_valid }
    end
  end

  describe ".release_status" do
    it "gives the right release statuses" do
      expect(described_class.release_status).to eq(release_status)
    end
  end

  describe ".deployment_status" do
    it "gives the right release statuses" do
      expect(described_class.deployment_status).to eq(deployment_status)
    end
  end
end
