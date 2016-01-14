class Release
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :summary, type: String
  belongs_to :status
  has_many :deployments

  before_save :default_status

  validates :name, presence: true

  index({ name: 1 })

  private

  def default_status
    self.status_id ||= Status.find_by(:name => Status::OPEN).id
  end
end
