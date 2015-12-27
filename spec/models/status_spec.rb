require "rails_helper"

RSpec.describe Status, type: :model do
  let(:status) { described_class.new }
  let(:statuses) {{
    1 => Status.create!(:id => 1, :name => "waiting to deploy"),
    2 => Status.create!(:id => 2, :name => "deploying"),
    3 => Status.create!(:id => 3, :name => "deployed"),
    4 => Status.create!(:id => 4, :name => "rollback"),
    5 => Status.create!(:id => 5, :name => "open"),
    6 => Status.create!(:id => 6, :name => "finish"),
    7 => Status.create!(:id => 7, :name => "cancelled")
  }}
  let(:release_status) { [statuses[Status::OPEN], statuses[Status::FINISH]] }
  let(:deployment_status) do
    [
      statuses[Status::WAIT_TO_DEPLOY],
      statuses[Status::DEPLOYING],
      statuses[Status::DEPLOYED],
      statuses[Status::ROLLBACK],
      statuses[Status::CANCELLED]
    ]
  end
  subject { status }

  it { is_expected.to respond_to(:name) }

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
    before do
      Rails.cache.clear
      statuses
    end

    it "gives the right release statuses" do
      expect(described_class.release_status).to eq(release_status)
    end

    it "does a database lookup once" do
      expect(described_class).to receive(:find).once
      described_class.release_status
      described_class.release_status
    end
  end

  describe ".deployment_status" do
    before do
      Rails.cache.clear
      statuses
    end

    it "gives the right release statuses" do
      expect(described_class.deployment_status).to eq(deployment_status)
    end

    it "does a database lookup once" do
      expect(described_class).to receive(:find).once
      described_class.deployment_status
      described_class.deployment_status
    end
  end
end
