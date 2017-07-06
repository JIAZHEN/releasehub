class Project < ActiveRecord::Base
  validates :deployment_id, presence: true
  validates :branch_id, presence: true
  validates :sha, presence: true
  validates :deployment_order, presence: true

  belongs_to :deployment
  belongs_to :branch

  delegate :repository, :to => :branch

  def deploy_commands
    @deploy_commands ||= DeployCommand.for(deployment.environment, repository, branch)
  end
end
