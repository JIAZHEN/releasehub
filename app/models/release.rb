class Release < ActiveRecord::Base
  before_save :default_status

  validates :name, presence: true

  belongs_to :status
  has_many :deployments

  private

  def default_status
    self.status_id ||= Status::OPEN
  end
end
