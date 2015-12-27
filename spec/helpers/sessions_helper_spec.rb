require "rails_helper"

RSpec.describe SessionsHelper, type: :helper do
  it "scopes user and repo" do
    expect(helper.scopes).to eq("user:email")
  end

  describe "#current_user" do
    context "when there's no remember_token in cookie" do
      it "returns nil" do
        expect(helper.current_user).to be_nil
      end
    end

    context "when there is remember_token in cookie" do
      let(:remember_token) { "123" }

      before do
        allow(User).to receive(:new_remember_token).and_return(remember_token)
        cookies[:remember_token] = remember_token
      end
      after { cookies.delete(:remember_token) }

      it "returns the user" do
        user = create(:user)
        expect(helper.current_user).to eq user
      end
    end
  end

  describe "#authenticated?" do
    context "when current_user is nil" do
      before { allow(helper).to receive(:current_user).and_return(nil) }

      it "returns false" do
        expect(helper.authenticated?).to eq(false)
      end
    end

    context "when current_user is not nil" do
      before { allow(helper).to receive(:current_user).and_return(User.new) }

      it "returns true" do
        expect(helper.authenticated?).to eq(true)
      end
    end
  end

  describe "#log_out" do
    before do
      cookies[:remember_token] = "123"
      helper.current_user = User.new
      helper.log_out
    end

    it "clear current user and cookies" do
      expect(current_user).to be_nil
      expect(cookies[:remember_token]).to be_nil
    end
  end

  describe "#log_in" do
    let(:remember_token) { "123" }

    before do
      @user = create(:user)
      allow(User).to receive(:new_remember_token).and_return(remember_token)
      helper.log_in @user
    end

    it "clear current user and cookies" do
      expect(helper.current_user).to eq @user
      expect(cookies[:remember_token]).to eq remember_token
    end
  end
end
