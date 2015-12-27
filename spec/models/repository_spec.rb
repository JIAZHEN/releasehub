require "rails_helper"

RSpec.describe Repository, type: :model do
  let(:repository) { described_class.new }
  subject { repository }

  it { is_expected.to respond_to(:active_branches) }
  it { is_expected.to respond_to(:branches) }
  it { is_expected.to respond_to(:name) }

  describe "#name" do
    describe "when name is not present" do
      it { is_expected.not_to be_valid }
    end

    describe "when name is empty" do
      before { repository.name = " " }

      it { is_expected.not_to be_valid }
    end

    describe "when name is over 50 characters" do
      before { repository.name = "a" * 51 }

      it { is_expected.not_to be_valid }
    end
  end
end
