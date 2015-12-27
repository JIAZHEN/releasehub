class Branch < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :repository
end
