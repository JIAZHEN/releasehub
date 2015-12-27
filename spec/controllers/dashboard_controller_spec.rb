require "rails_helper"
require_relative "../../app/helpers/sessions_helper"

RSpec.describe DashboardController, type: :controller do
  let(:authorize_url) { "http://github.authorize_url" }
  let(:authenticated) { false }
  before { allow(controller).to receive(:authenticated?).and_return(authenticated) }

  describe "#login" do
    let(:response) { get :login }

    context "when user is not authenticated" do
      before do
        allow(controller).to receive(:authorize_url).and_return(authorize_url)
      end

      it "redirects to authenrisation page" do
        expect(response).to redirect_to authorize_url
      end
    end

    context "when user is authenticated" do
      let(:authenticated) { true }

      it "redirects to authenrisation page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#callback" do
    let(:code) { "access_token_abc" }
    let(:response) { get :callback, :code => code }

    before do
      allow(controller).to receive(:exchange_token).and_return(code)
    end

    context "when user is not authenticated" do
      let(:github_user) { double("User", :login => "release" ) }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(github_user)
      end

      context "and callback with code" do
        let(:org_permit) { false }

        before do
          stub_const("ReleasesHelper::ORGANISATION", "releasehub")
          allow(controller).to receive(:organisation_permit?).and_return(org_permit)
        end

        it "does not log in and gives flash message when organisation is not permitted" do
          expect(response).to redirect_to root_path
          expect(cookies[:remember_token]).to be_nil
          expect(flash[:danger]).to eq("Sorry you don't have the permission to organisation releasehub.")
        end

        context "when slack name is blank" do
          let(:org_permit) { true }
          let(:github_user) { double("User", :login => "release", :name => nil, :avatar_url => "url" ) }

          it "logs in and gives flash message" do
            expect(response).to redirect_to edit_user_path(controller.current_user)
            expect(cookies[:remember_token]).not_to be_nil
            expect(flash[:warning]).to eq("Please double check your slack username.")
          end
        end

        context "when slack name is not blank" do
          let(:user) { create(:user) }
          let(:org_permit) { true }
          let(:github_user) { double("User", :login => user.github_login, :name => user.name, :avatar_url => user.avatar_url ) }

          it "logs in" do
            expect(response).to redirect_to root_path
            expect(cookies[:remember_token]).not_to be_nil
            expect(flash).to be_empty
          end
        end
      end

      context "and callback without code" do
        let(:code) { " " }

        it "does not exchange a new token and gives flash message" do
          expect(response).to redirect_to root_path
          expect(cookies[:remember_token]).to be_nil
          expect(flash[:danger]).to eq("Invalid callback code. Please check the application registeration and permission.")
        end
      end
    end

    context "when user is authenticated" do
      let(:authenticated) { true }

      it "does not need to exchange token" do
        expect(controller).not_to receive(:exchange_token)
      end
    end
  end

  describe "#destroy" do
    %i{ get post }.each do |http_method|
      context "visit via #{http_method} method" do
        it "returns 302 redirect" do
          public_send(http_method, :destroy)
          expect(response.status).to eq(302)
        end
      end
    end

    context "when user is authenticated and logged in" do
      before { cookies[:remember_token] = "a_token" }

      it "destroy the session" do
        delete :destroy
        expect(cookies[:remember_token]).to be_nil
      end

      it "redirects to root_path" do
        delete :destroy
        expect(response).to redirect_to root_path
      end
    end
  end
end
