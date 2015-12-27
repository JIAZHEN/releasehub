require "rails_helper"

RSpec.describe Release, type: :model do
  let(:release) { described_class.new }
  subject { release }

  it { is_expected.to respond_to(:status_id) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:summary) }
  it { is_expected.to respond_to(:deployments) }

  describe "#name" do
    context "when name is not present" do
      it { is_expected.not_to be_valid }
    end

    context "when name is empty" do
      before { release.name = " " }

      it { is_expected.not_to be_valid }
    end
  end

  describe "#summary" do
    context "when summary is not present" do
      it { is_expected.not_to be_valid }
    end

    context "when summary is empty" do
      before { release.summary = " " }

      it { is_expected.not_to be_valid }
    end
  end

  describe "default status" do
    before do
      @release = described_class.new(:name => "releasehub", :summary => "hello world")
    end

    it "set to open as default" do
      @release.save
      expect(@release.status_id).to eq(Status::OPEN)
    end
  end
end
