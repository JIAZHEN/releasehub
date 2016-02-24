class ReleasesController < ApplicationController

  SEARCH_KEYS = {
    "name" => "releases.name",
    "status" => "statuses.name",
    "created_at" => "releases.created_at",
    "summary" => "releases.summary"
  }

  def index
    @releases = Release.includes(:status, deployments: [:environment, :status, projects: [branch: [:repository]]]).order(:id => :desc).page(params[:page]).per(params[:per_page] || 30)
    @releases_status = Status.release_status if ops?
  end

  def show
    @release = Release.includes(:status, deployments: [:environment, :status, projects: [branch: [:repository]]]).find(params[:id])
    @deployment_status = Status.deployment_status if ops?
  end

  def get_branches
    if params["repository"] && (repository = Repository.find_by(name: params["repository"]))
      branches = if params["type"] == "sync".freeze
        sync_branches_from_github(repository)
      else
        repository.active_branches
      end
      respond_with_json branches
    else
      result = { error: "Invalid repository name" }
      respond_with_json result
    end
  end

  def get_sha
    branch = client.branch("#{ReleasesHelper::ORGANISATION}/#{params["repository"]}", params["branch"].strip)
    result = { sha: branch.commit[:sha] }
    respond_with_json result
  rescue Octokit::NotFound
    result = { error: "Invalid repository/branch name" }
    respond_with_json result
  end

  def update_status
    @release = Release.find(params["release_id"])
    @release.update(status_id: params["status_id"])
    result = { name: @release.status.name, colour: status_colour(@release) }
    respond_with_json result
  rescue ActiveRecord::RecordNotFound
    result = { error: "Invalid release id" }
    respond_with_json result
  end

  private

  def respond_with_json(data, status = 200)
    respond_to do |format|
      format.json { render json: data, status: status }
    end
  end

  def sync_branches_from_github(repository)
    names = client.branches("#{ReleasesHelper::ORGANISATION}/#{repository.name}").map do |branch|
      branch.name
    end
    # deactivate deleted branches
    repository.branches.update_all(:active => false)
    # activate branches
    Branch.where("id IN (?)", unique_branch_ids(repository, names)).update_all(:active => true)
    names.map do |name|
      repository.branches.find_or_create_by(name: name)
    end
  end

  def unique_branch_ids(repository, names)
    repository.branches.where("name IN (?)", names).group_by(&:name).
      reduce([]) { |sum, (name, records)| sum << records.first.id }
  end
end
