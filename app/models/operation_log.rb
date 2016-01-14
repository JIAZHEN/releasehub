class OperationLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  belongs_to :status
  belongs_to :deployment

  validates :status_id, presence: true
  validates :deployment_id, presence: true

  index({ username: 1 })

end
