class Environment < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 15 }

  PRODUCTION = "production"

  def production?
    name == PRODUCTION
  end
end
