module SlackHelper
  ActionView::Helpers::AssetUrlHelper

  SLACK_TOKEN = ENV["SLACK_TOKEN"]
  LOGO_URL = "https://dl.dropboxusercontent.com/u/44435189/releasehub-logo-48.png"
  SLACK_CHAT_URL = "https://slack.com/api/chat.postMessage"
  SLACK_USER_LIST_URL = "https://slack.com/api/users.list"
  SLACK_CHANNEL_LIST_URL = "https://slack.com/api/channels.list"

  def slack_post(channels, message)
    uri = URI.parse(SLACK_CHAT_URL)
    Array(channels).each do |channel|
      Net::HTTP.post_form(uri, {
        "token" => SLACK_TOKEN,
        "channel" => channel.strip,
        "attachments" => message,
        "link_names" => 1,
        "username" => "ReleaseHub",
        "as_user" => false,
        "icon_url" => LOGO_URL
      })
    end
  end

  def slack_notify_list
    Rails.cache.fetch("slack_notify_list", :expires_in => 1.day) do
      uri = URI.parse(SLACK_USER_LIST_URL)
      res = Net::HTTP.post_form(uri, "token" => SLACK_TOKEN)
      users = JSON.parse(res.body)["members"].map{ |member| {"name" => "@#{member["name"]}"} }

      uri = URI.parse(SLACK_CHANNEL_LIST_URL)
      res = Net::HTTP.post_form(uri, "token" => SLACK_TOKEN, "exclude_archived" => 1)
      channels = JSON.parse(res.body)["channels"].map{ |channel| {"name" => "##{channel["name"]}"} }

      (users + channels).to_json
    end
  end

  Below is for github deployment status
  Not in used for now
  def github_post
    {
      "create" => ->(release) { start_deployment(release) },
      "update_status" => ->(release) { update_deployment(release) }
    }
  end

  def start_deployment(release)
    payload = { :user => client.user.login }.to_json
    options = {
      payload: payload,
      environment: release.environment.name,
      description: release.description
    }
    release.projects.each do |project|
      response = client.create_deployment("#{ORGANISATION}/#{project.repository.name}",
        project.sha, options)
      project.update(deployment_id: response["id"])
    end
  end

  def update_deployment(release)
    release.projects.each do |project|
      endpoint = "repos/#{ORGANISATION}/#{project.repository.name}/deployments/#{project.deployment_id}}"
      client.create_deployment_status(endpoint, DEPLOYMENT_STATUS[release.status_id])
    end
  end
end
