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

    fields = [
      {
          title: "Projects",
          value: deployment.projects.map { |p| p.repository.name }.sort.join(", "),
          short: true
      }
    ]

    if deployment.notify_people?
      fields.push({
        title: "Notification list",
        value: deployment.notification_list.gsub(",", ", "),
        short: true
      })
    end

    base_text = "<#{deploy_url}|##{deployment.id})> (<#{release_url}|#{deployment.release.name}>) #{deployment.status.name} to #{deployment.environment.name} by @#{current_username}"
    base_text << " for @#{deployment.dev}" unless deployment.dev == current_username
    notif_text = deployment.notify_people? ? " /cc #{deployment.notification_list.gsub(',', ', ')}" : ""

    [{
      fallback: "#{base_text}#{notif_text}",
      text: base_text,
      fields: fields,
      color: STATUS_TO_SLACK_COLOUR[deployment.status_id]
    }].to_json
  end

  def status_colour(object, default = nil)
    STATUS_TO_COLOUR.fetch(object.status.id, default)
  end
end
