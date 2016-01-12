class OperationLog
  validates :status_id, presence: true
  validates :deployment_id, presence: true

  belongs_to :status
  belongs_to :deployment
end
