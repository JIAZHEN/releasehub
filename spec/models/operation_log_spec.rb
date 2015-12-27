require "rails_helper"

RSpec.describe OperationLog, type: :model do
  let(:project) { described_class.new }

  subject { project }

  it { is_expected.to respond_to(:deployment_id) }
  it { is_expected.to respond_to(:deployment) }
  it { is_expected.to respond_to(:status_id) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:username) }

  describe "when deployment_id is not present" do
    it { is_expected.not_to be_valid }
  end

  describe "when status_id is not present" do
    it { is_expected.not_to be_valid }
  end
end
