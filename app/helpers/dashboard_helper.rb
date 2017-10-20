module DashboardHelper

  ENVIRONMENT_COLOUR = {
    "qa1" => "qa",
    "qa2" => "qa",
    "qa3" => "qa",
    "qa4" => "qa",
    "qa5" => "qa",
    "uat1" => "uat",
    "uat2" => "uat",
    "production" => "live",
  }

  ALTER_ENV_NAME = {
    "production" => "live"
  }

  def env_to_colour(environment)
    ENVIRONMENT_COLOUR.fetch(environment, "qa")
  end

  def env_name(environment)
    ALTER_ENV_NAME.fetch(environment.name, environment.name)
  end

  def sha_url(repo, sha)
    "https://github.com/#{ReleasesHelper::ORGANISATION}/#{repo}/commit/#{sha}"
  end

  def branch_url(repo, branch)
    "https://github.com/#{ReleasesHelper::ORGANISATION}/#{repo}/pull/#{branch}"
  end

end
