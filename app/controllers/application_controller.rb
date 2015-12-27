class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == "application/json" }

  include ApplicationHelper
  include SessionsHelper
  include ReleasesHelper
  include DashboardHelper
  include SlackHelper

  before_action :require_authentication

  private

  def require_authentication
    unless authenticated?
      flash[:danger] = "Please login"
      redirect_to root_path
    end
  end
end
