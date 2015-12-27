require "rails_helper"

RSpec.describe Project, type: :model do
  let(:project) { described_class.new }

  subject { project }

  it { is_expected.to respond_to(:deployment_id) }
  it { is_expected.to respond_to(:deployment) }
  it { is_expected.to respond_to(:branch_id) }
  it { is_expected.to respond_to(:branch) }
  it { is_expected.to respond_to(:sha) }
  it { is_expected.to respond_to(:repository) }

  describe "when deployment_id is not present" do
    it { is_expected.not_to be_valid }
  end

  describe "when branch_id is not present" do
    it { is_expected.not_to be_valid }
  end
end
