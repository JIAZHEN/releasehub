class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  has_many :branches

  index({ name: 1 }, { unique: true })

  validates :name, presence: true, length: { maximum: 50 }

  def active_branches
    branches.where(:active => true).order(name: :asc)
  end
end
