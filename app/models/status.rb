class Status
  include Mongoid::Document

  WAIT_TO_DEPLOY = "wait_to_deploy"
  DEPLOYING = "deploying"
  DEPLOYED = "deployed"
  ROLLBACK = "rollback"
  CANCELLED = "cancelled"
  OPEN = "open"
  FINISH = "finish"

  RELEASE_STATUS = [OPEN, FINISH]
  DEPLOYMENT_STATUS = [WAIT_TO_DEPLOY, DEPLOYING, DEPLOYED, ROLLBACK, CANCELLED]

  field :name, type: String
  index({ name: 1 }, { unique: true })

  validates :name, presence: true, length: { maximum: 30 }

  scope :release_status, -> { where(:name.in => RELEASE_STATUS) }
  scope :deployment_status, -> { where(:name.in => DEPLOYMENT_STATUS) }
end
