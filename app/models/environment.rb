class Environment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  index({ name: 1 }, { unique: true })

  validates :name, presence: true, length: { maximum: 15 }

  PRODUCTION = "production"

  def production?
    name == PRODUCTION
  end
end
