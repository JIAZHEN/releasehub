class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sha, type: String
  field :deployment_instruction, type: String
  field :rollback_instruction, type: String
  belongs_to :deployment
  belongs_to :branch

  validates :deployment_id, presence: true
  validates :branch_id, presence: true
  validates :sha, presence: true

  delegate :repository, :to => :branch
end
