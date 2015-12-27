require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { described_class.new }

  subject { user }

  it { is_expected.to respond_to(:github_login) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:slack_username) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:avatar_url) }

  describe "Creating user" do
    let(:name) { "some good" }
    before do
      @user = described_class.new(:github_login => "someone", :name => name)
      @user.save
    end

    describe "Remember token" do
      it "must generate the token" do
        expect(@user.remember_token).not_to be_blank
      end
    end

    describe "#set_default_slack_username" do
      before { @user.set_default_slack_username }

      it "guess slack username as the initial + last name" do
        expect(@user.slack_username).to eq("sgood")
      end

      context "when name is blank" do
        let(:name) { "" }

        it "set slack username as blank" do
          expect(@user.slack_username).to be_blank
        end
      end

      context "when name is nil" do
        let(:name) { nil }

        it "doesn't set the slack username" do
          expect(@user.slack_username).to be_nil
        end
      end
    end
  end
end
