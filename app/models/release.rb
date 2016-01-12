class Release
  include Mongoid::Document

  field :name, type: String
  field :summary, type: String
  belongs_to :status
  has_many :deployments

  before_save :default_status

  validates :name, presence: true

  index({ name: 1 }, { unique: true })

  private

  def default_status
    self.status_id ||= Status::OPEN
  end
end
