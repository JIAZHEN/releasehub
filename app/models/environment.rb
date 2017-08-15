class Environment < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 15 }

  def production?
    name == "production"
  end

  def qa?
    name =~ /^qa/
  end
end
