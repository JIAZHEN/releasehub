class Deployment < ActiveRecord::Base
  validates :release_id, presence: true
  validates :status_id, presence: true
  validates :environment_id, presence: true
  validates :dev, presence: true

  belongs_to :release
  belongs_to :status
  belongs_to :environment
  has_many :projects
  has_many :operation_logs

  NOTIFY_STATUS = Set[Status::DEPLOYED, Status::ROLLBACK]

  def repo_names
    projects.map { |project| project.repository.name }.join(",")
  end

  def notify_people?
    NOTIFY_STATUS.include?(status_id)
  end

  def last_operator
    operation_logs.last
  end
end
