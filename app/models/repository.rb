class Repository < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }

  has_many :branches

  def active_branches
    branches.where(:active => true).order(name: :asc)
  end

  def wld?
    name == "wld"
  end
end
