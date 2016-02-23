class DashboardController < ApplicationController
  skip_before_action :require_authentication

  def index
    if authenticated?
      @today = Date.today.strftime("%Y-%m-%d")
      @lastest_deployments = Deployment.includes(:status, :operation_logs, :projects).
        where("status_id IN (?)", [Status::WAIT_TO_DEPLOY, Status::DEPLOYING]).
        order(:id => :asc).all
      @boxes_info = stagingnow
      @deployment_status = Status.deployment_status if ops?
    end
  end

  def login
    redirect_to(authenticated? ? root_path : authorize_url)
  end

  def callback
    unless authenticated?
      access_token = exchange_token(params[:code])
      if access_token.blank?
        flash[:danger] = "Invalid callback code. Please check the application registeration and permission.".freeze
        return redirect_to root_path
      else
        github_user = Octokit::Client.new(:access_token => access_token, :auto_paginate => true).user
        unless organisation_permit?(github_user.login)
          flash[:danger] = "Sorry you don't have the permission to organisation #{ReleasesHelper::ORGANISATION}.".freeze
          return redirect_to root_path
        end

        user = User.find_or_create_by(:github_login => github_user.login)
        user.update_attributes(:name => github_user.name, :avatar_url => github_user.avatar_url)
        log_in user
      end
    end

    if current_user.slack_username.blank?
      current_user.set_default_slack_username
      flash[:warning] = "Please double check your slack username.".freeze
      redirect_to edit_user_path(current_user)
    else
      redirect_to root_path
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def stagingnow
    deploys = Deployment.includes(:release, :projects).joins("LEFT OUTER JOIN
      deployments d2 ON (deployments.environment_id = d2.environment_id AND deployments.created_at < d2.created_at)")
      .where("d2.created_at IS NULL").all

    Environment.all.reduce({}) do |result, env|
      deploy = deploys.find { |delpoy| delpoy.environment_id == env.id }
      result.merge(env => deploy)
    end
  end
end
