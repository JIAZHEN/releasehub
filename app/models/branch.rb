class Branch
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :active, type: Boolean
  belongs_to :repository

  index({ name: 1 }, { unique: true })
  index({ repository: 1 }, { unique: true })

  validates :name, presence: true
end
