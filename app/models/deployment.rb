class Deployment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :notification_list, type: String
  field :dev, type: String
  belongs_to :release
  belongs_to :status
  belongs_to :environment
  has_many :projects
  has_many :operation_logs

  validates :release_id, presence: true
  validates :status_id, presence: true
  validates :environment_id, presence: true
  validates :dev, presence: true

  NOTIFY_STATUS = Set[Status::DEPLOYED, Status::ROLLBACK]

  index({ notification_list: 1 })
  index({ dev: 1 })

  def repo_names
    projects.order_by(:id => "ASC").map { |project| project.repository.name }.join(",")
  end

  def notify_people?
    NOTIFY_STATUS.include?(status.name)
  end
end
