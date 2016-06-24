module ReleasesHelper

  ORGANISATION = ENV["ORGANISATION"]

  STATUS_TO_COLOUR = {
    Status::FINISH => "success",
    Status::WAIT_TO_DEPLOY => "primary",
    Status::DEPLOYING => "warning",
    Status::DEPLOYED => "success",
    Status::ROLLBACK => "danger",
    Status::CANCELLED => "cancel"
  }

  STATUS_TO_SLACK_COLOUR = {
    Status::FINISH => "good",
    Status::WAIT_TO_DEPLOY => "#d3d3d3",
    Status::DEPLOYING => "warning",
    Status::DEPLOYED => "good",
    Status::ROLLBACK => "danger",
    Status::CANCELLED => "#333333"
  }

  def release_message(deployment)
    deploy_url = "https://#{request.host_with_port}#{deployment_path(deployment)}"
    release_url = "https://#{request.host_with_port}#{release_path(deployment.release)}"

    msg_text = "<#{deploy_url}|##{deployment.id}> (<#{release_url}|#{deployment.release.name}>) #{deployment.status.name} to #{deployment.environment.name} by #{current_username}"
    msg_text << " for @#{deployment.dev}" unless deployment.dev == current_username
    fallback_text = "##{deployment.id} (#{deployment.release.name}) #{deployment.status.name} to #{deployment.environment.name} by @#{current_username}: #{deploy_url}"

    payload = {
      fallback: fallback_text,
      text:     msg_text,
      color:    STATUS_TO_SLACK_COLOUR[deployment.status_id]
    }

    if deployment.last_operator && deployment.last_operator.created_at < 5.minutes.ago
      if deployment.notify_people?
        payload[:text] << " /cc #{deployment.notification_list.gsub(',', ', ')}"
      end
    else
      payload[:fields] = [
        {
            title: "Projects",
            value: deployment.projects.map { |p| p.repository.name }.join(", "),
            short: true
        }
      ]

      if deployment.notify_people?
        payload[:fields] << {
          title: "Notify",
          value: deployment.notification_list.gsub(",", ", "),
          short: true
        }
      end
    end

    [payload].to_json
  end

  def status_colour(object, default = nil)
    STATUS_TO_COLOUR.fetch(object.status.id, default)
  end
end
