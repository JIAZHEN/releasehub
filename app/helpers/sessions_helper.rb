module SessionsHelper

  CLIENT_ID = ENV["GITHUB_CLIENT_ID"]
  CLIENT_SECRET = ENV["GITHUB_CLIENT_SECRET"]
  ADMIN_ACCESS_TOKEN = ENV["GITHUB_ACCESS_TOKEN"]

  def scopes
    "user:email".freeze
  end

  def client
    @client ||= Octokit::Client.new(
      :access_token => ADMIN_ACCESS_TOKEN,
      :auto_paginate => true)
  end

  def authorize_url
    auth_client = Octokit::Client.new(:client_id => CLIENT_ID,
      :client_secret => CLIENT_SECRET)
    auth_client.authorize_url(CLIENT_ID, :scope => scopes)
  end

  def exchange_token(code)
    Octokit.exchange_code_for_token(code, CLIENT_ID, CLIENT_SECRET)[:access_token]
  end

  def authenticated?
    !current_user.nil?
  end

  def log_in user
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = { value: remember_token,
                                           expires: 20.years.from_now.utc }
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def log_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def current_username
    current_user.slack_username
  end

  def organisation_permit?(login)
    client.org_member?(ReleasesHelper::ORGANISATION, login)
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    return @current_user if @current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user = User.find_by(:remember_token => remember_token)
  end
end
