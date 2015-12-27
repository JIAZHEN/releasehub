require "rails_helper"

RSpec.describe Environment, type: :model do
  let(:environment) { described_class.new }
  subject { environment }

  it { is_expected.to respond_to(:name) }

  describe "#name" do
    describe "when name is not present" do
      it { is_expected.not_to be_valid }
    end

    describe "when name is empty" do
      before { environment.name = " " }

      it { is_expected.not_to be_valid }
    end

    describe "when name is over 15 characters" do
      before { environment.name = "a" * 16 }

      it { is_expected.not_to be_valid }
    end
  end
end
