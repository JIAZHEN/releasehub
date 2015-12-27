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

  def release_message(project_names, deployment)
    url = "https://#{request.host_with_port}#{deployment_path(deployment)}"
    fields = [
      {
          title: "Projects",
          value: project_names,
          short: true
      },
      {
          title: "Environment",
          value: deployment.environment.name,
          short: true
      },
      {
          title: "Dev",
          value: deployment.dev,
          short: true
      },
    ]

    if deployment.notify_people?
      fields.push({
        title: "Notification list",
        value: deployment.notification_list,
        short: true
      })
    end

    [{
      fallback: "<#{url}|RR(deployment-#{deployment.id})> is \"#{deployment.status.name}\" by @#{current_username} cc #{deployment.notification_list}",
      text: "<#{url}|RR(deployment-#{deployment.id})> is \"#{deployment.status.name}\" by @#{current_username}",
      fields: fields,
      color: STATUS_TO_SLACK_COLOUR[deployment.status_id]
    }].to_json
  end

  def status_colour(object, default = nil)
    STATUS_TO_COLOUR.fetch(object.status.id, default)
  end
end
